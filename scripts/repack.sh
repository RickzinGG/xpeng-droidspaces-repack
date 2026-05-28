#!/usr/bin/env bash

set -e

echo "Baixando magiskboot..."

# ✅ baixa binário correto (fixo)
curl -L -o magiskboot https://raw.githubusercontent.com/chenxiaolong/DualBootPatcher/master/prebuilts/magiskboot/x86_64/magiskboot

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
