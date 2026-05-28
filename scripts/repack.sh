#!/usr/bin/env bash

set -e

echo "Clonando ferramentas AOSP..."

git clone --depth=1 https://github.com/osm0sis/mkbootimg.git tools

cd tools

echo "Preparando ferramentas..."

chmod +x mkbootimg unpackbootimg

cd ..

echo "Extraindo boot.img..."

./tools/unpackbootimg -i boot.img -o unpacked

echo "Substituindo kernel..."

KERNEL=""

if [ -f kernel/out/arch/arm64/boot/Image.gz-dtb ]; then
    KERNEL="kernel/out/arch/arm64/boot/Image.gz-dtb"
elif [ -f kernel/out/arch/arm64/boot/Image.gz ]; then
    KERNEL="kernel/out/arch/arm64/boot/Image.gz"
else
    KERNEL="kernel/out/arch/arm64/boot/Image"
fi

cp "$KERNEL" unpacked/kernel

echo "Recriando boot.img..."

./tools/mkbootimg \
  --kernel unpacked/kernel \
  --ramdisk unpacked/ramdisk.gz \
  --cmdline "$(cat unpacked/boot.img-cmdline)" \
  --base $(cat unpacked/boot.img-base) \
  --pagesize $(cat unpacked/boot.img-pagesize) \
  --output droidspaces_boot.img

echo "PRONTO ✅"
