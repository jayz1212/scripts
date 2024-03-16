#!/bin/bash
rm -rf .repo/local_manifests hardware/qcom-caf
mkdir .repo/local_manifests
cp scripts/roomservice.xml .repo/local_manifests
mv scripts/statix.xml .repo/manifests/snippets
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
source build/envsetup.sh
#m clean
#make clean
ccache -s

 rm out/target/product/*/*.zip
# source scripts/fixes.sh
#source build/envsetup.sh && lunch evolution_h872-eng && (while true; do clear; ccache -s; sleep 60; done) & m -j$(nproc --all) evolution

source build/envsetup.sh
lunch cipher_h872-eng

m -j$(nproc --all) bacon
