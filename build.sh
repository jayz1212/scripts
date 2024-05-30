#!/bin/bash
repo init -u https://github.com/LineageOS/android.git -b lineage-20.0 --git-lfs



rm -rf .repo/local_manifests

mkdir -p .repo/local_manifests
cp scripts/roomservice.xml .repo/local_manifests


repo init --git-lfs
rm -rf external/chromium-webview/prebuilt/*
rm -rf .repo/projects/external/chromium-webview/prebuilt/*.git
rm -rf .repo/project-objects/LineageOS/android_external_chromium-webview_prebuilt_*.git

/opt/crave/resync.sh


source build/envsetup.sh




lunch lineage_us997-userdebug
m installclean
m bacon





