#!/bin/bash

print_this_dir() {
  (
    cd "$(dirname "$0")"
    pwd
  )
}

readonly __DIR__="$(print_this_dir)"

${__DIR__}/docker_run.sh cbc "$@"
