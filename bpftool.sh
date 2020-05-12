#!/bin/bash

source /etc/os-release

if [ "$ID" = "cos" ]; then
    if [ ! -d "/tmp/kernel_headers" ]; then
        wget https://storage.googleapis.com/cos-tools/${BUILD_ID}/kernel-headers.tgz -P /tmp/
        mkdir /tmp/kernel_headers
        tar -zxvf /tmp/kernel-headers.tgz -C /tmp/kernel_headers/
        rm /tmp/kernel-headers.tgz
    fi

    docker run --rm -it \
        --env BCC_KERNEL_SOURCE=/tmp/kernel_headers/usr/src/linux-headers-$(uname -r) \
        --env BPFTRACE_KERNEL_SOURCE=/tmp/kernel_headers/usr/src/linux-headers-$(uname -r) \
        -v /tmp/kernel_headers:/tmp/kernel_headers:ro \
        -v /lib/modules/:/lib/modules:ro \
        -v /sys/kernel/debug:/sys/kernel/debug:rw \
        --net=host --pid=host --privileged \
        dialogbox/bpftools:cos-${BUILD_ID}
else
  echo This is a script to use bpftool from COS
  echo If you use ubuntu, you can just install linux-tools-common package

fi
