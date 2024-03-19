#!/bin/bash
# Set default values for device and command
repo init -u https://github.com/LineageOS/android.git -b lineage-18.1 --git-lfs
/opt/crave/resync.sh
