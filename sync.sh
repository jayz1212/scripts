#!/bin/bash
# Function to wait for 1 second

rm -rf .repo/local_manifests hardware/qcom-caf
mkdir .repo/local_manifests
cp scripts/roomservice.xml .repo/local_manifests
cp scripts/lineage.xml .repo/local_manifests
cp scripts/crdroid.xml .repo/local_manifests
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
source build/envsetup.sh
#m clean
#make clean
# ccache -s

#  rm out/target/product/*/*.zip
# # source scripts/fixes.sh
# #source build/envsetup.sh && lunch evolution_h872-eng && (while true; do clear; ccache -s; sleep 60; done) & m -j$(nproc --all) evolution

# source build/envsetup.sh
# lunch evolution_h872-eng

# m -j$(nproc --all) evolution
# #lunch lineage_us997-userdebug
# #m -j$(nproc --all) bacon
# #lunch lineage_h870-userdebug
# #m -j$(nproc --all) bacon
