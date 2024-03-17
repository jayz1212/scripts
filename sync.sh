#!/bin/bash
repo init -u https://github.com/crdroidandroid/android.git -b 14.0 --git-lfs
rm -rf .repo/local_manifests
mkdir .repo/local_manifests
cp scripts/roomservice.xml .repo/local_manifests
mv scripts/statix.xml .repo/manifests/snippets
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
chmod +x tsync.sh
. tsync.sh
#m clean
#make clean


