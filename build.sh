#!/bin/bash
git lfs install
repo init -u https://github.com/LineageOS/android.git -b lineage-20.0 --git-lfs
git lfs install



rm -rf .repo/local_manifests

mkdir -p .repo/local_manifests
cp scripts/roomservice.xml .repo/local_manifests


repo init --git-lfs
rm -rf external/chromium-webview/prebuilt/*
rm -rf .repo/projects/external/chromium-webview/prebuilt/*.git
rm -rf .repo/project-objects/LineageOS/android_external_chromium-webview_prebuilt_*.git

/opt/crave/resync.sh


source build/envsetup.sh
cd device/lge/msm8996-common
git fetch https://github.com/LineageOS/android_device_lge_msm8996-common.git lineage-21
git cherry-pick 202b7b2a91cd8cf3816f93f90942f1fdf5ebb92f
sed -i 's/$(call inherit-product, $(SRC_TARGET_DIR)\/product\/non_ab_device\.mk)//g' msm8996.mk

cd ../../../



lunch lineage_us997-userdebug
m installclean
m bacon





