#!/bin/bash
# Function to wait for 1 second
wait_one_second() {
    sleep 1
}

# Remove existing build artifacts
wait_one_second && rm -rf out/target/product/*/*.zip device/lge/msm8996-common

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
rm out/target/product/*/*.zip
source scripts/fixes.sh

rm -rf lineage-sdk &&git clone https://github.com/crdroidandroid/android_lineage-sdk -b 14.0 lineage-sdk
rm -rf vendor/evolution&&git clone https://github.com/xc112lg/vendor_evolution -b udc1 vendor/evolution
mv scripts/NotificationGroup.aidl frameworks/base/core/java/android/app/
mv scripts/NotificationGroup.java frameworks/base/core/java/android/app/
mv -f scripts/Android.bp frameworks/base/
mv -f scripts/fd_utils.cpp frameworks/base/core/jni
mv -f scripts/sdk.go build/soong/java/
mv -f scripts/AssetManager.cpp frameworks/base/libs/androidfw/
mv -f scripts/android_manifest.go build/soong/java/
mv -f scripts/Idmap2Service.cpp frameworks/base/cmds/idmap2/idmap2d/
mv -f scripts/Idmap2Service.h frameworks/base/cmds/idmap2/idmap2d/
mv -f scripts/app.go build/soong/java/
mv -f scripts/AssetManager.java frameworks/base/core/java/android/content/res/
mv -f scripts/aar.go build/soong/java/
mv -f scripts/OverlayConfig.java frameworks/base/core/java/com/android/internal/content/om/
mv -f scripts/java.go build/soong/java/ 
mv -f scripts/androidmk.go build/soong/java/ 
mv -f scripts/testing.go build/soong/java/ 
mv -f scripts/app_test.go build/soong/java/ 
rm -rf frameworks/base/core/java/com/android/internal/custom 
rm -rf frameworks/base/core/java/com/android/internal/util/custom/palette
rm -rf frameworks/base/core/java/com/android/internal/util/custom/ActionUtils.java
rm -rf frameworks/base/core/java/com/android/internal/util/custom/ColorUtils.java
rm -rf frameworks/base/core/java/com/android/internal/util/custom/Concierge.java 
rm -rf frameworks/base/core/java/com/android/internal/util/custom/FileUtils.java 
rm -rf frameworks/base/core/java/com/android/internal/util/custom/MathUtils.java 
source build/envsetup.sh
lunch evolution_h872-eng

m -j$(nproc --all) evolution
#lunch lineage_us997-userdebug
#m -j$(nproc --all) bacon
#lunch lineage_h870-userdebug
#m -j$(nproc --all) bacon