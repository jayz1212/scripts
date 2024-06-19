#!/bin/bash





rm -rf .repo/local_manifests device/lge build/tools frameworks/base vendor/lineage-priv/keys
rm -rf  ~/.android-certs/
mkdir -p .repo/local_manifests
cp scripts/roomservice.xml .repo/local_manifests
#rm -rf ~/.android-certs

repo init --git-lfs
rm -rf external/chromium-webview/prebuilt/*
rm -rf .repo/projects/external/chromium-webview/prebuilt/*.git
rm -rf .repo/project-objects/LineageOS/android_external_chromium-webview_prebuilt_*.git
repo init -u https://github.com/LineageOS/android.git -b lineage-20.0 --git-lfs
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

#chmod +x scripts/generate_certs.sh
#source scripts/generate_certs.sh
git clone https://gitlab.com/MindTheGapps/vendor_gapps -b tau vendor/gapps
ls ./.android-certs/

export GH_TOKEN=$(cat gh_token.txt)
git clone https://$GH_TOKEN@github.com/xc112lg/keys -b main vendor/lineage-priv/keys
ls vendor/lineage-priv/keys
# source build/envsetup.sh
# cd build/tools
# git fetch https://github.com/xc112lg/android_build.git patch-1
# git cherry-pick b7b12b875a97eee6e512c74c53a82066e237a31a
# cd ../../

cd frameworks/base
# git fetch https://github.com/jayz1212/android_frameworks_base.git patch-1
# git cherry-pick ceaafedfc058ebcf509b16f146dfe5331889e345
sleep 1
git fetch https://github.com/jayz1212/android_frameworks_base.git patch-2
git cherry-pick 33c2bde34a5f73c16a84ee512e5342e5b620d9c9
sleep 1
git cherry-pick ceaafedfc058ebcf509b16f146dfe5331889e345
sleep 1

sleep 1
git cherry-pick c1b8a711cf055962976a3597eb958f2bbf3c3087
#git fetch https://github.com/crdroidandroid/android_frameworks_base.git 14.0
git cherry-pick 2f6f9e05e5f95ef2e7859a3759d9828f951b4475
cd ../../



sed -i '/include $(LOCAL_PATH)\/vendor_prop.mk/a include vendor/gapps/arm64/arm64-vendor.mk' device/lge/msm8996-common/msm8996.mk
#sed -i 's/183621644ce05/183181402cc4c/g' device/lge/h872/lineage_h872.mk
#cat device/lge/h872/lineage_h872.mk


source build/envsetup.sh

    lunch lineage_us997-userdebug
    m installclean
    m -j$(nproc --all) bacon
    lunch lineage_h870-userdebug
    m installclean
    m -j$(nproc --all) bacon

#lunch lineage_us997-userdebug
lunch lineage_h872-userdebug
m installclean
m bacon
