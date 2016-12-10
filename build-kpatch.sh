#!/bin/sh
set -xe

docker build -t rancher/os-kernel-kpatch:4.4.21-rancher1-1 os-kpatch

cd os-mypatch
../dapper

cd dist
docker build -t roast/mykpatch:0.7.0 .
docker push roast/mykpatch:0.7.0
