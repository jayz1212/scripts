#!/bin/bash

# Directory containing XML files
xml_dir=".repo/manifests"

# Get the list of paths from the XML files
paths=$(xmlstarlet sel -t -v "//project/@path" "$xml_dir"/*.xml)

# Save the current directory
original_dir=$(pwd)

# Function to convert date to epoch
date_to_epoch() {
  date -d "$1" +%s
}

# Target date
TARGET_DATE="2024-03-12"
target_epoch=$(date_to_epoch "$TARGET_DATE")

# Log file
LOG_FILE="script.log"

# Initialize a list to store reverted commits
reverted_commits=()

# Iterate over each path
for path in $paths; do
  # Check if the path is a directory
  if [ -d "$path" ]; then
    # Change to the directory
    cd "$path" || { echo "Failed to cd into $path"; exit 1; }
    
    # List the contents
    echo "Listing contents of $path:" | tee -a "$LOG_FILE"
    ls | tee -a "$LOG_FILE"
    
    # Get the list of commits with their dates
    commits=$(git log --pretty=format:"%H %cd" --date=iso 2>>"$LOG_FILE")
    if [ $? -ne 0 ]; then
      echo "Failed to retrieve git log." | tee -a "$LOG_FILE"
      cd "$original_dir" || exit 1
      continue
    fi

    last_commit_before_target=""
    last_commit_date_before_target=""

    # Iterate over the commits
    echo "Processing commits..." | tee -a "$LOG_FILE"
    echo "$commits" | while IFS= read -r line; do
      commit_hash=$(echo "$line" | awk '{print $1}')
      commit_date=$(echo "$line" | cut -d' ' -f2-)
      
      # Convert commit date to epoch time
      commit_epoch=$(date_to_epoch "$commit_date")

      if [ $commit_epoch -le $target_epoch ]; then
        last_commit_before_target=$commit_hash
        last_commit_date_before_target=$commit_date
      else
        # Once we find a commit after the target date, we can stop
        break
      fi
    done

    if [ -n "$last_commit_before_target" ]; then
      echo "Last commit before $TARGET_DATE: $last_commit_before_target, date: $last_commit_date_before_target" | tee -a "$LOG_FILE"
      
      # Revert the last commit before the target date
      echo "Reverting commit before $TARGET_DATE: $last_commit_before_target" | tee -a "$LOG_FILE"
      git revert --no-commit "$last_commit_before_target" 2>>"$LOG_FILE"
      if [ $? -ne 0 ]; then
        echo "Failed to revert commit: $last_commit_before_target" | tee -a "$LOG_FILE"
        cd "$original_dir" || exit 1
        continue
      fi

      # Remove files added by the reverted commit
      git diff --name-only "$last_commit_before_target" | xargs rm -rf

      git commit -am "Revert commit $last_commit_before_target" 2>>"$LOG_FILE"
      if [ $? -ne 0 ]; then
        echo "Failed to commit revert" | tee -a "$LOG_FILE"
        cd "$original_dir" || exit 1
        continue
      fi

      # Check if the commit has been reverted
      revert_check=$(git log --grep="Revert" --grep="$last_commit_before_target" 2>>"$LOG_FILE")
      if [ -n "$revert_check" ]; then
        echo "Commit $last_commit_before_target has been successfully reverted." | tee -a "$LOG_FILE"
        # Add to the list of reverted commits
        reverted_commits+=("$last_commit_before_target")
      else
        echo "Revert of commit $last_commit_before_target failed." | tee -a "$LOG_FILE"
      fi
    else
      echo "No commit found before $TARGET_DATE" | tee -a "$LOG_FILE"
    fi

    # Change back to the original directory
    cd "$original_dir" || { echo "Failed to cd back to $original_dir"; exit 1; }
  else
    echo "$path is not a directory or does not exist." | tee -a "$LOG_FILE"
  fi
done

# Echo all reverted commits
echo "All reverted commits:" | tee -a "$LOG_FILE"
for commit in "${reverted_commits[@]}"; do
  echo "$commit" | tee -a "$LOG_FILE"
done

# Echo if no commit was found
if [ -z "${reverted_commits[*]}" ]; then
  echo "No commit found before $TARGET_DATE" | tee -a "$LOG_FILE"
fi
