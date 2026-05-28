#!/usr/bin/env bash

set -e

# pega clang
CLANG_BIN=$(find clang -type f -name "clang" | head -n 1)
CLANG_BIN_DIR=$(dirname $CLANG_BIN)

echo "Clang bin: $CLANG_BIN_DIR"
ls $CLANG_BIN_DIR

export PATH="$CLANG_BIN_DIR:$PATH"

cd kernel

export ARCH=arm64
export SUBARCH=arm64

mkdir -p out

DEFCONFIG_NAME=gki_defconfig

echo "Usando: $DEFCONFIG_NAME"

# ✅ FORÇA LLVM JÁ AQUI
make O=out $DEFCONFIG_NAME LLVM=1 LLVM_IAS=1
make O=out olddefconfig LLVM=1 LLVM_IAS=1

# ✅ BUILD COMPLETO COM LLVM
make -j$(nproc --all) \
    O=out \
    LLVM=1 \
    LLVM_IAS=1 \
    CC=clang \
    LD=ld.lld \
    AR=llvm-ar \
    NM=llvm-nm \
    OBJCOPY=llvm-objcopy \
    OBJDUMP=llvm-objdump \
    STRIP=llvm-strip \
    KCFLAGS="-Wno-error" \
    KBUILD_MODPOST_WARN=1
