#!/usr/bin/env bash

set -e

echo "Baixando magiskboot..."

# ✅ baixa binário pronto (funciona 100%)
curl -L -o magiskboot https://github.com/topjohnwu/Magisk/releases/latest/download/magiskboot

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
