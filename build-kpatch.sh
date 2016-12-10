#!/bin/sh
set -xe

# Add kpatch to the base image that contains the DEBUG_INFO build kernel
docker build -t rancher/os-kernel-kpatch:4.4.21-rancher1-1 os-kpatch

# build the patch module (by re-building the kernel another 2 times)
cd os-mypatch
../dapper


# build a small Ubuntu container that can kpatch load it
cd dist
docker build -t roast/mykpatch:0.7.0 .
docker push roast/mykpatch:0.7.0
