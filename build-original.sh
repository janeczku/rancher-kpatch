#!/bin/sh
set -ex

# prepare rancher/os-kernel-build:4.4.21-rancher1-1
if [ ! -d os-kernel ]; then
	git clone https://github.com/rancher/os-kernel
	cd os-kernel
	# use ./.dapper --keep release
	cp ../dapper .dapper
	git checkout Ubuntu-4.4.0-42.62-rancher1-1
	git checkout -b 4.4.21-rancher-debug
	sed -i~ 's/.*CONFIG_DEBUG_INFO.*/CONFIG_DEBUG_INFO=y/g' config/kernel-config
	sed -i~ 's/CONFIG_LOCALVERSION.*/CONFIG_LOCALVERSION="-rancher-debug"/g' config/kernel-config
	git commit -a -s -m "enable DEBUG_INFO - needed for kpatch"
	./.dapper --keep release

	#TODO: yup, need to automate tagging that image
fi


