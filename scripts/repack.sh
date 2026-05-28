#!/usr/bin/env bash

set -e

echo "Baixando Magisk APK (fixo)..."

# 🔥 link fixo (não quebra igual latest)
curl -L -o magisk.apk https://github.com/topjohnwu/Magisk/releases/download/v30.7/Magisk-v30.7.apk

echo "Extraindo magiskboot..."

unzip -j magisk.apk "lib/x86_64/libmagiskboot.so" -d .

mv libmagiskboot.so magiskboot
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

echo "PRONTO ✅ droidspaces_boot.img gerado"
