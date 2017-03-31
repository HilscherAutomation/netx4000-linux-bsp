#!/bin/bash

git submodule update --init yocto/

pushd yocto

if [ "$1" = "--native" ]; then
	shift
	./build.sh $@
else
	./build_docker.sh $@
fi

popd
