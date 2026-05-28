#!/usr/bin/env bash

set -e

echo "Preparando ferramentas..."

# 🔥 instala deps básicas
sudo apt update
sudo apt install -y git build-essential

# 🔥 se não tiver unpackbootimg, compila
if ! command -v unpackbootimg &> /dev/null
then
    echo "unpackbootimg não encontrado, compilando..."

    git clone https://github.com/anestisb/android-unpackbootimg.git tools_unpack
    cd tools_unpack

    make

    cp unpackbootimg ../
    cp mkbootimg ../

    cd ..
fi

echo "Extraindo boot.img..."

mkdir -p work
cd work

../unpackbootimg -i ../boot.img

echo "Arquivos extraídos:"
ls

# detecta nomes automaticamente
RAMDISK=$(ls *ramdisk* 2>/dev/null | head -n1)
CMDLINE=$(cat *cmdline*)
BASE=$(cat *base*)
PAGESIZE=$(cat *pagesize*)

echo "Ramdisk: $RAMDISK"

echo "Substituindo kernel..."

if [ -f ../kernel/out/arch/arm64/boot/Image.gz-dtb ]; then
    cp ../kernel/out/arch/arm64/boot/Image.gz-dtb kernel
elif [ -f ../kernel/out/arch/arm64/boot/Image.gz ]; then
    cp ../kernel/out/arch/arm64/boot/Image.gz kernel
else
    cp ../kernel/out/arch/arm64/boot/Image kernel
fi

echo "Reempacotando boot..."

../mkbootimg \
  --kernel kernel \
  --ramdisk "$RAMDISK" \
  --cmdline "$CMDLINE" \
  --base "$BASE" \
  --pagesize "$PAGESIZE" \
  -o ../droidspaces_boot.img

cd ..

echo "PRONTO ✅ droidspaces_boot.img gerado"
