#!/bin/bash

print_project_dir() {
  local real_path="$(readlink --canonicalize "$0")"
  (
    cd "$(dirname "$real_path")"
    pwd
  )
}

export PROJECT_DIR="$(print_project_dir)"
export TEST_DIR="${PROJECT_DIR}/test/json"
export TEMP_DIR="${PROJECT_DIR}/z_tmp"

ERRS=""
MAX_ID=6

test_nn() {
  local nn="$1"; shift
  nn="${nn}"

  local temp_json_file="${TEMP_DIR}/test.json"

  echo "test_${nn}"

  local exp_tokens_file="${TEST_DIR}/${nn}.json"

  cat ${TEST_DIR}/${nn}.json \
    | bin/test_json \
    > $temp_json_file
  if [ $? -ne 0 ]; then
    ERRS="${ERRS},${nn}_json"
    return
  fi

  ruby test_common/diff.rb json-fmt $exp_tokens_file $temp_json_file
  if [ $? -ne 0 ]; then
    # meld $exp_tokens_file $temp_json_file &

    ERRS="${ERRS},${nn}_diff"
    return
  fi
}

# --------------------------------

mkdir -p z_tmp

if [ "$BUILD_DONE" != "1" ]; then
  rake build 1>&2
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
  echo "ok"
else
  echo "----"
  echo "FAILED: ${ERRS}"
  exit 1
fi
