#!/bin/bash

# Update and install ccache
sudo apt-get update -y
sudo apt-get install -y apt-utils
sudo apt-get install -y ccache
export USE_CCACHE=1
ccache -M 100G
export CCACHE_DIR=${PWD}/cc
ccache -s
ccache --set-config=compression=false
ccache --show-config | grep compression
echo $CCACHE_DIR

if [ -z "$(ls -A c)" ]; then
  echo "Folder c is empty. Skipping the rsync command."
else
  # If folder c is not empty, execute the rsync command
time ls -1 c | xargs -I {} -P 10 -n 1 rsync -au c/{} cc/
cp -f c/ccache.conf cc
fi



repo init -u https://github.com/crdroidandroid/android.git -b 14.0 --git-lfs
rm -rf .repo/local_manifests
mkdir .repo/local_manifests
cp scripts/roomservice.xml .repo/local_manifests
mv scripts/statix.xml .repo/manifests/snippets
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
chmod +x tsync.sh
source scripts/tsync.sh
source build/envsetup.sh
    lunch lineage_us997-userdebug
    m installclean
    m -j$(nproc --all) bacon


time ls -1 cc | xargs -I {} -P 10 -n 1 rsync -au cc/{} c/
cp -f cc/ccache.conf c
ccache -s


