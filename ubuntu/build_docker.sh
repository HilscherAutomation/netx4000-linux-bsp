#!/bin/bash

docker build -t ubuntu-buildenv:16.04 docker/.

docker run --privileged -it --rm -v $(pwd):/build -u `id -u` ubuntu-buildenv:16.04 /build/build.sh $@
