#!/usr/bin/env bash

set -e

echo "Clonando Magisk..."

git clone --depth=1 https://github.com/topjohnwu/Magisk.git magisk

echo "Baixando NDK..."

curl -L -o ndk.zip https://dl.google.com/android/repository/android-ndk-r26b-linux.zip
unzip -q ndk.zip
mv android-ndk-r26b ndk

export ANDROID_NDK_HOME=$PWD/ndk

echo "Compilando magiskboot..."

cd magisk/native

$ANDROID_NDK_HOME/ndk-build NDK_PROJECT_PATH=. APP_BUILD_SCRIPT=Android.mk

cd ../../

cp magisk/native/libs/x86_64/magiskboot magiskboot
chmod +x magiskboot

echo "Testando magiskboot..."
./magiskboot --help || { echo "Erro no magiskboot"; exit 1; }

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
