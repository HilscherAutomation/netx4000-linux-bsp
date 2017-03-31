#!/bin/bash

git submodule update --init ubuntu/

pushd ubuntu

if [ "$1" = "--native" ]; then
	shift
	./build.sh $@
else
	./build_docker.sh $@
fi

popd
