#!/bin/bash

docker build -t yocto-buildenv:2.2 docker/.

docker run -it --rm -v $(pwd):/build -u `id -u` yocto-buildenv:2.2 /build/build.sh $@
