#!/bin/bash

print_project_dir() {
  local real_path="$(readlink --canonicalize "$0")"
  (
    cd "$(dirname "$real_path")"
    pwd
  )
}

export PROJECT_DIR="$(print_project_dir)"
export TEST_DIR="${PROJECT_DIR}/test"
export TEMP_DIR="${PROJECT_DIR}/z_tmp"

ERRS=""
MAX_ID=2

test_nn() {
  local nn="$1"; shift
  nn="${nn}"

  local temp_tokens_file="${TEMP_DIR}/test.tokens.txt"

  echo "test_${nn}"

  local exp_tokens_file="${TEST_DIR}/tokenize_exp_${nn}.txt"

  cat ${TEST_DIR}/tokenize_${nn}.vg.txt \
    | bin/vgtokenizer \
    > $temp_tokens_file
  if [ $? -ne 0 ]; then
    ERRS="${ERRS},${nn}_tokenize"
    return
  fi

  ruby test/diff.rb $exp_tokens_file $temp_tokens_file
  if [ $? -ne 0 ]; then
    # meld $exp_tokens_file $temp_tokens_file &

    ERRS="${ERRS},${nn}_diff"
    return
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
  echo "tokenize: ok"
else
  echo "----"
  echo "FAILED: ${ERRS}"
  exit 1
fi
