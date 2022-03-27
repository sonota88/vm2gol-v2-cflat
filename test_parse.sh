#!/bin/bash

print_project_dir() {
  local real_path="$(readlink --canonicalize "$0")"
  (
    cd "$(dirname "$real_path")"
    pwd
  )
}

export PROJECT_DIR="$(print_project_dir)"
export TEST_DIR="${PROJECT_DIR}/test/parse"
export TEMP_DIR="${PROJECT_DIR}/z_tmp"

ERRS=""
MAX_ID=1

test_nn() {
  local nn="$1"; shift
  nn="${nn}"

  local temp_tokens_file="${TEMP_DIR}/test.tokens.txt"
  local temp_vgt_file="${TEMP_DIR}/test.vgt.json"
  local local_errs=""

  echo "test_${nn}"

  local exp_vga_file="${TEST_DIR}/exp_${nn}.vgt.json"

  echo "  tok" >&2
  cat ${TEST_DIR}/${nn}.vg.txt | bin/vgtokenizer > $temp_tokens_file
  if [ $? -ne 0 ]; then
    ERRS="${ERRS},${nn}_tokenize"
    local_errs="${local_errs},${nn}_tokenize"
    return
  fi

  echo "  parse" >&2
  cat $temp_tokens_file | bin/vgparser > $temp_vgt_file
  if [ $? -ne 0 ]; then
    ERRS="${ERRS},${nn}_parse"
    local_errs="${local_errs},${nn}_parse"
    return
  fi

  if [ "$local_errs" = "" ]; then
    ruby test/diff.rb $exp_vga_file $temp_vgt_file
    if [ $? -ne 0 ]; then
      # meld $exp_vga_file $temp_vga_file &

      ERRS="${ERRS},${nn}_diff"
      return
    fi
  fi
}

# --------------------------------

mkdir -p z_tmp

if [ "$BUILD_DONE" != "1" ]; then
  rake clean build 1>&2
  if [ $? -ne 0 ]; then
    echo "Compilation failed" >&2
    exit 1
  fi
fi

ns=

if [ $# -eq 1 ]; then
  ns="$1"
else
  ns="$(seq 1 ${MAX_ID})"
fi

for n in $ns; do
  test_nn $(printf "%02d" $n)
done

if [ "$ERRS" = "" ]; then
  echo "parse: ok"
else
  echo "----"
  echo "FAILED: ${ERRS}"
  exit 1
fi
