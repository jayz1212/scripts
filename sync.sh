#!/bin/bash
# Function to wait for 1 second
wait_one_second() {
    sleep 1
}

# Remove existing build artifacts
wait_one_second && rm -rf out/target/product/*/*.zip device/lge/msm8996-common
ccache -s
# Update and install ccache
wait_one_second && sudo apt-get update -y
wait_one_second && sudo apt-get install -y --no-install-recommends apt-utils
wait_one_second && sudo apt-get install -y ccache
wait_one_second && export USE_CCACHE=1
wait_one_second && export CCACHE_DIR=${PWD}/cc
wait_one_second && ccache -M 100G
echo $CCACHE_DIR
echo $CCACHE_EXEC
rm -rf .repo/local_manifests
mkdir .repo/local_manifests
cp scripts/roomservice.xml .repo/local_manifests
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
source build/envsetup.sh
#m clean
#make clean
ccache -s

# rm out/target/product/*/*.zip
# source scripts/fixes.sh

# source build/envsetup.sh
# lunch evolution_h872-eng

# ccache m -j$(nproc --all) evolution
#lunch lineage_us997-userdebug
#m -j$(nproc --all) bacon
#lunch lineage_h870-userdebug
#m -j$(nproc --all) bacon
