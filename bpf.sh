#!/bin/bash

source /etc/os-release

if [ "$ID" = "debian" ] || [ "$ID" = "ubuntu" ]; then
    [ ! -d /usr/src/linux-headers-$(uname -r) ] && sudo apt-get install -y linux-headers-$(uname -r)

    sudo docker run --rm -it \
        -v /usr/src:/usr/src:ro \
        -v /lib/modules/:/lib/modules:ro \
        -v /sys/kernel/debug:/sys/kernel/debug:rw \
        --net=host --pid=host --privileged \
        dialogbox/bpfbase:latest

elif [ "$ID" = "cos" ]; then
    if [ ! -d "/tmp/kernel_headers" ]; then
        wget https://storage.googleapis.com/cos-tools/${BUILD_ID}/kernel-headers.tgz -P /tmp/
        mkdir /tmp/kernel_headers
        tar -zxvf /tmp/kernel-headers.tgz -C /tmp/kernel_headers/
    fi
    if [ ! -d "/tmp/kernel_src" ]; then
        wget https://storage.googleapis.com/cos-tools/${BUILD_ID}/kernel-src.tar.gz -P /tmp/
        # wget https://storage.googleapis.com/cos-tools/${BUILD_ID}/toolchain.tar.xz -P /tmp/
        mkdir /tmp/kernel_src
        tar -zxvf /tmp/kernel-src.tar.gz -C /tmp/kernel_src/
    fi

    docker run --rm -it \
        --env BCC_KERNEL_SOURCE=/tmp/kernel_headers/usr/src/linux-headers-$(uname -r) \
        --env BPFTRACE_KERNEL_SOURCE=/tmp/kernel_headers/usr/src/linux-headers-$(uname -r) \
        -v /tmp/kernel_headers:/tmp/kernel_headers:ro \
        -v /lib/modules/:/lib/modules:ro \
        -v /sys/kernel/debug:/sys/kernel/debug:rw \
        --net=host --pid=host --privileged \
        dialogbox/bpfbase:latest
fi
