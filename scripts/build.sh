#!/usr/bin/env bash

set -e

# ✅ pega clang antes de tudo
CLANG_BIN=$(find clang -type f -name "clang" | head -n 1)
CLANG_BIN_DIR=$(dirname $CLANG_BIN)

echo "Clang bin: $CLANG_BIN_DIR"
ls $CLANG_BIN_DIR

export PATH="$CLANG_BIN_DIR:$PATH"

cd kernel

export ARCH=arm64
export SUBARCH=arm64

export LLVM=1
export LLVM_IAS=1

export CC=clang
export LD=ld.lld
export AR=llvm-ar
export NM=llvm-nm
export OBJCOPY=llvm-objcopy
export OBJDUMP=llvm-objdump
export STRIP=llvm-strip

mkdir -p out

# ✅ DEFCONFIG CORRETO
DEFCONFIG_NAME=gki_defconfig

echo "Usando: $DEFCONFIG_NAME"

make O=out $DEFCONFIG_NAME
make O=out olddefconfig

make -j$(nproc --all) \
    O=out \
    CC=clang \
    LD=ld.lld \
    LLVM=1 \
    LLVM_IAS=1 \
    KCFLAGS="-Wno-error" \
    KBUILD_MODPOST_WARN=1
