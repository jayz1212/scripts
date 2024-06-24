#!/bin/bash





rm -rf .repo/local_manifests device/lge/msm8996-common
rm -rf  ~/.android-certs/
mkdir -p .repo/local_manifests
cp scripts/roomservice.xml .repo/local_manifests
#rm -rf ~/.android-certs

repo init --git-lfs
rm -rf external/chromium-webview/prebuilt/*
rm -rf .repo/projects/external/chromium-webview/prebuilt/*.git
rm -rf .repo/project-objects/LineageOS/android_external_chromium-webview_prebuilt_*.git
repo init -u https://github.com/LineageOS/android.git -b lineage-21.0 --git-lfs

main() {
    # Run repo sync command and capture the output
    repo sync -c -j20 --force-sync --no-clone-bundle --no-tags 2>&1 | tee /tmp/output.txt

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
        repo sync -c -j20 --force-sync --no-clone-bundle --no-tags
    else
        echo "All repositories synchronized successfully."
    fi
}

main $*


https://github.com/jayz1212/android_device_lge_msm8996-common -b patch-1 device/lge/msm8996-common

source build/envsetup.sh

#repopick -p 395676
#repopick -p 395670
#breakfast h872
#brunch h872 eng



lunch lineage_h872-ap2a-eng
m installclean
m bacon


# for file in out/target/product/*/*.zip; do mv "$file" "${file%.zip}_copy.zip"; done





# rm -rf .repo/local_manifests kernel/lge/msm8996 device/lge/msm8996-common
# rm -rf  ~/.android-certs/
# mkdir -p .repo/local_manifests
# cp scripts/roomservice.xml .repo/local_manifests
# #rm -rf ~/.android-certs

# repo init --git-lfs
# rm -rf external/chromium-webview/prebuilt/*
# rm -rf .repo/projects/external/chromium-webview/prebuilt/*.git
# rm -rf .repo/project-objects/LineageOS/android_external_chromium-webview_prebuilt_*.git
# repo init -u https://github.com/LineageOS/android.git -b lineage-21.0 --git-lfs

# main() {
#     # Run repo sync command and capture the output
#     repo sync -c -j20 --force-sync --no-clone-bundle --no-tags 2>&1 | tee /tmp/output.txt

#     # Check if there are any failing repositories
#     if grep -q "Failing repos:" /tmp/output.txt ; then
#         echo "Deleting failing repositories..."
#         # Extract failing repositories from the error message and echo the deletion path
#         while IFS= read -r line; do
#             # Extract repository name and path from the error message
#             repo_info=$(echo "$line" | awk -F': ' '{print $NF}')
#             repo_path=$(dirname "$repo_info")
#             repo_name=$(basename "$repo_info")
#             # Echo the deletion path
#             echo "Deleted repository: $repo_info"
#             # Save the deletion path to a text file
#             echo "Deleted repository: $repo_info" > deleted_repositories.txt
#             # Delete the repository
#             rm -rf "$repo_path/$repo_name"
#         done <<< "$(cat /tmp/output.txt | awk '/Failing repos:/ {flag=1; next} /Try/ {flag=0} flag')"

#         # Re-sync all repositories after deletion
#         echo "Re-syncing all repositories..."
#         repo sync -c -j20 --force-sync --no-clone-bundle --no-tags
#     else
#         echo "All repositories synchronized successfully."
#     fi
# }

# main $*

# cd device/lge/msm8996-common
# sleep 1 &&git fetch https://github.com/xc112lg/android_device_lge_msm8996-common.git patch-10
# sleep 1 &&git cherry-pick 069b2d107a20986a82574a38b3730cf749c371af 

# sleep 1 &&git cherry-pick d331b47d5c5bf04714bd283fffee075cf84fa6fb
# cd ../../../

# source build/envsetup.sh


# #repopick -p 395676
# #repopick -p 395670
# #breakfast h872
# #brunch h872 eng



# lunch lineage_h872-ap2a-eng
# m installclean
# m bacon

