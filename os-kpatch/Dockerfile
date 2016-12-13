
# this is to build rancher/os-kernel-kpatch:4.4.21-rancher1-1
# because the built kernel image is 35GB, we could make this
# base image only include the tools, the source files and the
# vmlinuz with debug info?
FROM rancherbuild/os-kernel:linux-4.4.21-rancher-debug

RUN apt-get update \
    && apt-get install -yq make gcc libelf-dev dpkg-dev ccache \
                           gawk

RUN mkdir -p /lib/modules/4.4.21-rancher \
    && ln -s /usr/src/$(ls /usr/src | tr -d '\n')/ /lib/modules/4.4.21-rancher/build


# get the kpatch-build tool
COPY rancher0.7.0.patch .
RUN git clone https://github.com/dynup/kpatch \
    && cd kpatch \
    && patch  -p1 < ../rancher0.7.0.patch \
    && make \
    && make install


