#!/bin/bash

rm -rf external/chromium-webview/prebuilt/*
rm -rf .repo/projects/external/chromium-webview/prebuilt/*.git
rm -rf .repo/project-objects/LineageOS/android_external_chromium-webview_prebuilt_*.git

repo init --depth=1 --no-repo-verify -u https://github.com/RisingTechOSS/android -b thirteen --git-lfs -g default,-mips,-darwin,-notdefault


export WITH_GMS := true

rm -rf .repo/local_manifests device/lge build/tools frameworks/base vendor/gapps vendor/lineage
rm -rf  ~/.android-certs/
mkdir -p .repo/local_manifests
cp scripts/roomservice.xml .repo/local_manifests
#rm -rf ~/.android-certs



# git clone https://gitlab.com/MindTheGapps/vendor_gapps -b tau vendor/gapps

main() {
    # Run repo sync command and capture the output
    repo sync -c -j64 --force-sync --no-clone-bundle --no-tags 2>&1 | tee /tmp/output.txt

    # Check if there are any failing repositories
    if grep -q "Failing repos:" /tmp/output.txt ; then
        echo "Deleting failing repositories..."
        # Extract failing repositories from the error message and echo the deletion path
        while IFS= read -r line; do
            # Extract repository name and path from the error message
            repo_info=$(echo "$line" | awk -F': ' '{print $NF}')
            repo_path=$(dirname "$repo_info")
            repo_name=$(basename "$repo_info")
            # Echo the deletion path
            echo "Deleted repository: $repo_info"
            # Save the deletion path to a text file
            echo "Deleted repository: $repo_info" > deleted_repositories.txt
            # Delete the repository
            rm -rf "$repo_path/$repo_name"
        done <<< "$(cat /tmp/output.txt | awk '/Failing repos:/ {flag=1; next} /Try/ {flag=0} flag')"

        # Re-sync all repositories after deletion
        echo "Re-syncing all repositories..."
        repo sync -c -j64 --force-sync --no-clone-bundle --no-tags
    else
        echo "All repositories synchronized successfully."
    fi
}

main $*



ls ./.android-certs/


# source build/envsetup.sh
# cd build/tools
# git fetch https://github.com/xc112lg/android_build.git patch-1
# git cherry-pick b7b12b875a97eee6e512c74c53a82066e237a31a
# cd ../../

# cd frameworks/base
# # git fetch https://github.com/jayz1212/android_frameworks_base.git patch-1
# # git cherry-pick ceaafedfc058ebcf509b16f146dfe5331889e345
# sleep 1
# git fetch https://github.com/jayz1212/android_frameworks_base.git patch-2
# git cherry-pick 33c2bde34a5f73c16a84ee512e5342e5b620d9c9
# sleep 1
# git cherry-pick ceaafedfc058ebcf509b16f146dfe5331889e345
# sleep 1

# sleep 1
# git cherry-pick c1b8a711cf055962976a3597eb958f2bbf3c3087
#git fetch https://github.com/crdroidandroid/android_frameworks_base.git 14.0
#git cherry-pick 72042e3cd6451b5b14e9b549892611758986e162
#cd ../../




#rm -rf ~/.android-certs vendor/extra/keys


#echo "PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/extra/keys/releasekey" > vendor/extra/product.mk
# cat << 'EOF' >  vendor/lineage-priv/keys/BUILD.bazel
# filegroup(
#     name = "android_certificate_directory",
#     srcs = glob([
#         "*.pk8",
#         "*.pem",
#     ]),
#     visibility = ["//visibility:public"],
# )
# EOF





#lunch lineage_us997-userdebug
# lunch lineage_h872-userdebug
# m installclean
# m bacon

# rm -rf .repo/local_manifests device/lge/msm8996-common build/tools

# mkdir -p .repo/local_manifests
# cp scripts/roomservice.xml .repo/local_manifests


# repo init --git-lfs
# rm -rf external/chromium-webview/prebuilt/*
# rm -rf .repo/projects/external/chromium-webview/prebuilt/*.git
# rm -rf .repo/project-objects/LineageOS/android_external_chromium-webview_prebuilt_*.git

# /opt/crave/resync.sh


# source build/envsetup.sh
# cd device/lge/msm8996-common
# # git fetch https://github.com/LineageOS/android_device_lge_msm8996-common.git lineage-21
# # git cherry-pick 202b7b2a91cd8cf3816f93f90942f1fdf5ebb92f
# # sed -i 's/$(call inherit-product, $(SRC_TARGET_DIR)\/product\/non_ab_device\.mk)//g' msm8996.mk
# sed -i '/BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true/a\BUILD_BROKEN_INCORRECT_PARTITION_IMAGES := true' BoardConfigCommon.mk

# # git fetch https://github.com/LineageOS/android_device_lge_msm8996-common.git lineage-21
# # git cherry-pick bc3eabcf8adca63c5bd17d61a3066b5d40bdf72f
# cd ../../../
# sed -i '/-include device\/lge\/msm8996-common\/BoardConfigCommon.mk/a\-include vendor/lineage-priv/keys/keys.mk' device/lge/g6-common/BoardConfigCommon.mk
# cd build/tools
# git fetch https://github.com/xc112lg/android_build.git patch-1
# git cherry-pick b7b12b875a97eee6e512c74c53a82066e237a31a
# cd ../../

# subject='/C=DE/ST=Germany/L=Berlin/O=Max Mustermann/OU=Max Mustermann/CN=Max Mustermann/emailAddress=max@mustermann.de'
# mkdir ~/.android-certs

# for x in releasekey platform shared media networkstack testkey cyngn-priv-app bluetooth sdk_sandbox verifiedboot; do \
#  yes "" |   ./development/tools/make_key ~/.android-certs/$x "$subject"; \
# done
#sed -i '/-include device\/lge\/msm8996-common\/BoardConfigCommon.mk/a\-include vendor/lineage-priv/keys/keys.mk' device/lge/g6-common/BoardConfigCommon.mk
if [ -f vendor/extra/product.mk ]; then
    echo "File exists, Skipping key generation"
else
   chmod +x scripts/generate_certs.sh
source scripts/generate_certs.sh
sed -i '/include $(LOCAL_PATH)\/vendor_prop.mk/a -include vendor/lineage-priv/keys/keys.mk' device/lge/msm8996-common/msm8996.mk
#sed -i '/include $(LOCAL_PATH)\/vendor_prop.mk/a include vendor/gapps/arm64/arm64-vendor.mk' device/lge/msm8996-common/msm8996.mk
mkdir vendor/lineage-priv
cp -r ~/.android-certs vendor/lineage-priv/keys
echo "PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/lineage-priv/keys/releasekey" > vendor/lineage-priv/keys/keys.mk
cat << 'EOF' >  vendor/lineage-priv/keys/BUILD.bazel
filegroup(
    name = "android_certificate_directory",
    srcs = glob([
        "*.pk8",
        "*.pem",
    ]),
    visibility = ["//visibility:public"],
)
EOF
fi






cd vendor/qcom/opensource/vibrator


git fetch https://github.com/jayz1212/android_vendor_qcom_opensource_vibrator.git patch-1

git cherry-pick 2c89f15f97270415cf209e5de3f92ab2de752b8c
cd ../../../../



source build/envsetup.sh

    # lunch lineage_us997-userdebug
    # m installclean
    # m -j$(nproc --all) bacon
    # lunch lineage_h870-userdebug
    # m installclean
    # m -j$(nproc --all) bacon
    lunch lineage_h872-userdebug
    m installclean
    m -j$(nproc --all) bacon
