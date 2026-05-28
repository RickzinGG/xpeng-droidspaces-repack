#!/usr/bin/env bash

set -e

cd kernel

export ARCH=arm64
export SUBARCH=arm64

export LLVM=1
export LLVM_IAS=1

# ✅ PEGA O CAMINHO REAL DO CLANG
CLANG_PATH=$(find ../clang -type d -name "bin" | head -n 1)
export PATH="$CLANG_PATH:$PATH"

# ✅ GARANTE QUE ld.lld existe
ls $CLANG_PATH

export CC=clang
export LD=ld.lld
export AR=llvm-ar
export NM=llvm-nm
export OBJCOPY=llvm-objcopy
export OBJDUMP=llvm-objdump
export STRIP=llvm-strip

mkdir -p out

DEFCONFIG_NAME=vendor/gki_defconfig

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
