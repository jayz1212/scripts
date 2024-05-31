#!/bin/bash
git lfs install
repo init -u https://github.com/LineageOS/android.git -b lineage-20.0 --git-lfs
git lfs install


rm -rf .repo/local_manifests device/lge/msm8996-common

mkdir -p .repo/local_manifests
cp scripts/roomservice.xml .repo/local_manifests


repo init --git-lfs
rm -rf external/chromium-webview/prebuilt/*
rm -rf .repo/projects/external/chromium-webview/prebuilt/*.git
rm -rf .repo/project-objects/LineageOS/android_external_chromium-webview_prebuilt_*.git

/opt/crave/resync.sh


source build/envsetup.sh
cd device/lge/msm8996-common
# git fetch https://github.com/LineageOS/android_device_lge_msm8996-common.git lineage-21
# git cherry-pick 202b7b2a91cd8cf3816f93f90942f1fdf5ebb92f
# sed -i 's/$(call inherit-product, $(SRC_TARGET_DIR)\/product\/non_ab_device\.mk)//g' msm8996.mk
sed -i '/BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true/a\BUILD_BROKEN_INCORRECT_PARTITION_IMAGES := true' BoardConfigCommon.mk
# git fetch https://github.com/LineageOS/android_device_lge_msm8996-common.git lineage-21
# git cherry-pick bc3eabcf8adca63c5bd17d61a3066b5d40bdf72f
cd ../../../

cd build/tools
git fetch https://github.com/xc112lg/android_build.git patch-1
git cherry-pick 694e43d946ee01e61b0ea0d705e5537a616d7c89
cd ../../



lunch lineage_us997-userdebug
m installclean
m bacon






rm -rf .repo/local_manifests device/lge/msm8996-common build/tools

mkdir -p .repo/local_manifests
cp scripts/roomservice.xml .repo/local_manifests


repo init --git-lfs
rm -rf external/chromium-webview/prebuilt/*
rm -rf .repo/projects/external/chromium-webview/prebuilt/*.git
rm -rf .repo/project-objects/LineageOS/android_external_chromium-webview_prebuilt_*.git

/opt/crave/resync.sh


source build/envsetup.sh
cd device/lge/msm8996-common
# git fetch https://github.com/LineageOS/android_device_lge_msm8996-common.git lineage-21
# git cherry-pick 202b7b2a91cd8cf3816f93f90942f1fdf5ebb92f
# sed -i 's/$(call inherit-product, $(SRC_TARGET_DIR)\/product\/non_ab_device\.mk)//g' msm8996.mk
sed -i '/BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true/a\BUILD_BROKEN_INCORRECT_PARTITION_IMAGES := true' BoardConfigCommon.mk
# git fetch https://github.com/LineageOS/android_device_lge_msm8996-common.git lineage-21
# git cherry-pick bc3eabcf8adca63c5bd17d61a3066b5d40bdf72f
cd ../../../

cd build/tools
git fetch https://github.com/xc112lg/android_build.git patch-2
git cherry-pick c00e85dc1de9217628cdb166af48e13addae360e
cd ../../



lunch lineage_us997-userdebug
m installclean
m bacon
