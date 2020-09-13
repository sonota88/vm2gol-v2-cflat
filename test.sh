#!/bin/bash

print_this_dir() {
  local real_path="$(readlink --canonicalize "$0")"
  (
    cd "$(dirname "$real_path")"
    pwd
  )
}

ERRS=""

test_all() {
  rake clean build
  if [ $? -ne 0 ]; then
    echo "Compilation failed" >&2
    exit 1
  fi

  export BUILD_DONE=1

  echo "==== json ===="
  ./test_json.sh
  if [ $? -ne 0 ]; then
    ERRS="${ERRS},${nn}_json"
    return
  fi

  echo "==== tokenize ===="
  ./test_tokenize.sh
  if [ $? -ne 0 ]; then
    ERRS="${ERRS},${nn}_tokenize"
    return
  fi

  echo "==== parse ===="
  ./test_parse.sh
  if [ $? -ne 0 ]; then
    ERRS="${ERRS},${nn}_parser"
    return
  fi

  echo "==== step ===="
  ./test_step.sh
  if [ $? -ne 0 ]; then
    ERRS="${ERRS},${nn}_step"
    return
  fi
}

# --------------------------------

test_all

if [ "$ERRS" = "" ]; then
  echo "----"
  echo "ok"
else
  echo "----"
  echo "FAILED: ${ERRS}"
  exit 1
fi
