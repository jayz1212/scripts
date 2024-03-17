#!/bin/bash
mkdir -p cc
mkdir -p c
# Update and install ccache
sudo apt-get update -y
sudo apt-get install -y apt-utils
sudo apt-get install -y ccache
sleep 1
export USE_CCACHE=1
sleep 1
export CCACHE_DIR=$PWD/cc
sleep 1 
ccache -M 100G
ccache -s
sleep 1
ccache --set-config=compression=false
ccache --show-config | grep compression
echo $CCACHE_DIR
ccache -s
if [ -z "$(ls -A c)" ]; then
  echo "Folder c is empty. Skipping the rsync command."
else
  # If folder c is not empty, execute the rsync command
time ls -1 c | xargs -I {} -P 10 -n 1 rsync -au c/{} cc/
cp -f c/ccache.conf cc
fi
ccache -s


repo init -u https://github.com/LineageOS/android.git -b lineage-18.1 --git-lfs
rm -rf .repo/local_manifests
mkdir .repo/local_manifests
cp scripts/roomservice.xml .repo/local_manifests



# Define the log file path
log_file="deleted_repos.log"

# Sync repositories and capture failed repositories
failed_repos=$(repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags 2>&1 | grep "Failing repos")

# If there are failed repositories, delete them and log the deletion
if [ -n "$failed_repos" ]; then
    echo "Deleting failing repositories..."
    # Extract failing repositories from the error message and log the deletion
    while IFS= read -r line; do
        repo_name=$(echo "$line" | cut -d':' -f2)
        echo "Deleted repository: $repo_name" >> "$log_file"
        rm -rf "$repo_name"
    done <<< "$failed_repos"
    
    # Re-sync all repositories after deletion
    echo "Re-syncing all repositories..."
    repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
fi


source build/envsetup.sh



