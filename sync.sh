#!/bin/bash
# Function to wait for 1 second
wait_one_second() {
    sleep 1
}
mkdir -p cc
mkdir -p c
cp -f cc/ccache.conf c/ccache.conf 
time ls -1 cc | xargs -I {} -P 5 -n 1 rsync -au cc/{} c/
#time rsync -au --parallel=8 ${PWD}/cc  ${PWD}/c
#cp -rf ${PWD}/cc  ${PWD}/c
# Remove existing build artifacts
wait_one_second && rm -rf out/target/product/*/*.zip device/lge/msm8996-common
ccache -s
# Update and install ccache
sudo apt-get install dialog
sudo apt-get -y install --reinstall ccache

wait_one_second && sudo apt-get update -y
wait_one_second && sudo apt-get install -y --no-install-recommends apt-utils
wait_one_second && sudo apt-get install -y ccache
wait_one_second && export USE_CCACHE=1
ccache -s
wait_one_second && export CCACHE_DIR=${PWD}/cc
wait_one_second && ccache -M 100G
ccache -s
ccache -s
ccache -o compression=false
ccache --show-config | grep compression
echo $CCACHE_DIR
echo $CCACHE_EXEC
time ls -1 c | xargs -I {} -P 5 -n 1 rsync -au c/{} cc/
cp -f c/ccache.conf cc/ccache.conf 
ccache -o compression=false
ccache --show-config | grep compression

rm -rf .repo/local_manifests
mkdir .repo/local_manifests
cp scripts/roomservice.xml .repo/local_manifests
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
source build/envsetup.sh
#m clean
#make clean
ccache -s

 rm out/target/product/*/*.zip
# source scripts/fixes.sh
#source build/envsetup.sh && lunch evolution_h872-eng && (while true; do clear; ccache -s; sleep 60; done) & m -j$(nproc --all) evolution

source build/envsetup.sh
lunch evolution_h872-eng

m -j$(nproc --all) evolution
#lunch lineage_us997-userdebug
#m -j$(nproc --all) bacon
#lunch lineage_h870-userdebug
#m -j$(nproc --all) bacon
