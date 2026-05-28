#!/usr/bin/env bash

set -e

echo "Instalando magiskboot via pacote..."

# usa binário confiável (mbtool inclui magiskboot compatível)
sudo apt update
sudo apt install -y android-sdk-libsparse-utils

# fallback: usar avbtool + unpack manual (mais estável)
echo "Usando método alternativo (unpack direto)..."

mkdir work
cd work

# extrai boot com unpackbootimg (já vem no sistema)
unpackbootimg -i ../boot.img

echo "Substituindo kernel..."

if [ -f ../kernel/out/arch/arm64/boot/Image.gz-dtb ]; then
    cp ../kernel/out/arch/arm64/boot/Image.gz-dtb kernel
elif [ -f ../kernel/out/arch/arm64/boot/Image.gz ]; then
    cp ../kernel/out/arch/arm64/boot/Image.gz kernel
else
    cp ../kernel/out/arch/arm64/boot/Image kernel
fi

echo "Reempacotando boot..."

mkbootimg \
  --kernel kernel \
  --ramdisk boot.img-ramdisk.gz \
  --cmdline "$(cat boot.img-cmdline)" \
  --base "$(cat boot.img-base)" \
  --pagesize "$(cat boot.img-pagesize)" \
  -o ../droidspaces_boot.img

cd ..

echo "PRONTO ✅"
