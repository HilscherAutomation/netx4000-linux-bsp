#!/bin/bash

IMAGE=$@
if [ -z "${IMAGE}" ]; then
  IMAGE="core-image-minimal"
fi

TEMPLATECONF=$(pwd)/meta-hilscher-netx4000/conf source poky/oe-init-build-env build
echo "Building ${IMAGE}"
bitbake ${IMAGE}
