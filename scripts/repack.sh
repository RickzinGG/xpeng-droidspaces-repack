#!/usr/bin/env bash

set -e

echo "Baixando Magisk..."

git clone --depth=1 https://github.com/topjohnwu/Magisk.git magisk

echo "Compilando magiskboot..."

cd magisk/native/src
ndk-build

cd ../../..

echo "Pegando magiskboot..."

cp magisk/native/libs/*/magiskboot .

chmod +x magiskboot

echo "Extraindo boot.img..."

./magiskboot unpack boot.img

echo "Substituindo kernel..."

if [ -f kernel/out/arch/arm64/boot/Image.gz-dtb ]; then
    cp kernel/out/arch/arm64/boot/Image.gz-dtb kernel
elif [ -f kernel/out/arch/arm64/boot/Image.gz ]; then
    cp kernel/out/arch/arm64/boot/Image.gz kernel
else
    cp kernel/out/arch/arm64/boot/Image kernel
fi

echo "Reempacotando..."

./magiskboot repack boot.img

mv new-boot.img droidspaces_boot.img

echo "PRONTO ✅"
