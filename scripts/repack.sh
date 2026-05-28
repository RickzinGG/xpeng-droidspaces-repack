#!/usr/bin/env bash

set -e

echo "Clonando ferramentas AOSP..."

git clone --depth=1 https://github.com/osm0sis/mkbootimg.git tools

cd tools

echo "Preparando scripts..."

chmod +x mkbootimg.py unpack_bootimg.py

cd ..

mkdir -p unpacked

echo "Extraindo boot.img..."

python3 tools/unpack_bootimg.py --boot_img boot.img --out unpacked

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

python3 tools/mkbootimg.py \
  --kernel unpacked/kernel \
  --ramdisk unpacked/ramdisk \
  --cmdline "$(cat unpacked/cmdline)" \
  --base $(cat unpacked/base) \
  --pagesize $(cat unpacked/pagesize) \
  --output droidspaces_boot.img

echo "PRONTO ✅"
