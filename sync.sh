#!/bin/bash



repo init -u https://github.com/crdroidandroid/android.git -b 14.0 --git-lfs
rm -rf .repo/local_manifests
mkdir .repo/local_manifests
cp scripts/roomservice.xml .repo/local_manifests


# Define the log file path
log_file="deleted_repos.log"

# Sync repositories and capture the output
output=$(repo sync -c -j64 --force-sync --no-clone-bundle --no-tags 2>&1)

# Check if there are any failing repositories
if echo "$output" | grep -q "error:"; then
    echo "Deleting failing repositories..."
    # Extract failing repositories from the error message and log the deletion
    while IFS= read -r line; do
        repo_name=$(echo "$line" | awk '{print $NF}')
        echo "Attempting to delete repository: $repo_name"
        rm -rf "$repo_name"
        if [ $? -eq 0 ]; then
            echo "Deleted repository: $repo_name" >> "$log_file"
        else
            echo "Failed to delete repository: $repo_name"
        fi
    done <<< "$(echo "$output" | grep "Failing repos")"
    
    # Re-sync all repositories after deletion
    echo "Re-syncing all repositories..."
    repo sync -c -j64 --force-sync --no-clone-bundle --no-tags
else
    echo "All repositories synchronized successfully."
fi




source build/envsetup.sh
    lunch lineage_us997-userdebug
    m installclean
    m -j$(nproc --all) bacon


time ls -1 cc | xargs -I {} -P 10 -n 1 rsync -au cc/{} c/
cp -f cc/ccache.conf c
ccache -s


