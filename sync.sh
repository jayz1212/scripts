#!/bin/bash



repo init -u https://github.com/crdroidandroid/android.git -b 14.0 --git-lfs




while true; do
    errors=$(repo sync -j64 --fail-fast --force-sync --no-clone-bundle --no-tags 2>&1 | awk '/^error: Exited sync due to errors/,/^error: Cannot fetch .* in/ {print $0}' | tee /dev/tty)
    if [ -z "$errors" ]; then
        echo "No errors found. Exiting loop."
        break
    fi
    echo "$errors" | awk '/^error: Exited sync due to errors/,/^error: Cannot fetch .* in/ {print "rm -rf " $NF}' | bash
done

