#!/usr/bin/env bash

set -e

echo "Baixando magiskboot compatível..."

# 🔥 binário já pronto e compatível com GitHub runner
curl -L -o magiskboot https://raw.githubusercontent.com/affggh/magiskboot_builds/main/magiskboot

chmod +x magiskboot

echo "Testando magiskboot..."
./magiskboot --help || { echo "magiskboot quebrado"; exit 1; }

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
