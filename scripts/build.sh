#!/usr/bin/env bash

set -e

cd kernel

export ARCH=arm64
export SUBARCH=arm64

mkdir -p out

DEFCONFIG_NAME=gki_defconfig

echo "Usando: $DEFCONFIG_NAME"

make O=out $DEFCONFIG_NAME LLVM=1 LLVM_IAS=1
make O=out olddefconfig LLVM=1 LLVM_IAS=1

make -j$(nproc --all) \
    O=out \
    LLVM=1 \
    LLVM_IAS=1 \
    CC="clang --target=aarch64-linux-gnu" \
    LD=ld.lld \
    AR=llvm-ar \
    NM=llvm-nm \
    OBJCOPY=llvm-objcopy \
    OBJDUMP=llvm-objdump \
    STRIP=llvm-strip \
    KCFLAGS="-Wno-error" \
    KBUILD_MODPOST_WARN=1
