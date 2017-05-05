#!/bin/bash

docker build -t yocto-buildenv:2.3 docker/.

docker run -it --rm -v $(pwd):/build -u `id -u` yocto-buildenv:2.3 /build/build.sh $@
