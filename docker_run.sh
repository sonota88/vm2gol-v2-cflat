#!/bin/bash

docker run --rm -it \
  -v"$(pwd):/home/${USER}/work" \
  vm2gol-v2-cflat:0.0.1 "$@"
