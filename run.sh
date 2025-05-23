#!/bin/bash

# set environment variables
#git clone --depth=1 https://github.com/picasso09/proton-clang clang
#mkdir clang && cd clang && wget https://android.googlesource.com/platform//prebuilts/clang/host/linux-x86/+archive/refs/heads/main/clang-r522817.tar.gz && tar xf clang-r522817.tar.gz && rm clang-r522817.tar.gz && cd ..
export KBUILD_BUILD_HOST="kitty"
export KBUILD_BUILD_USER="meow"
export PATH="$(pwd)/clang/bin:$PATH"

# build kernel
make -j$(nproc --all) O=out ARCH=arm64 defconfig
make -j$(nproc --all) ARCH=arm64 O=out \
                      HOSTCC="ccache clang" \
                      HOSTCXX="ccache clang++" \
                      CC="ccache clang" \
                      CROSS_COMPILE=aarch64-linux-gnu- \
                      CROSS_COMPILE_ARM32=arm-linux-gnueabi-

mkdir dist
make O=out INSTALL_MOD_PATH=dist modules_install
make O=out INSTALL_PATH=dist install
cd dist
tar -czf ../kernel.tar.gz .
