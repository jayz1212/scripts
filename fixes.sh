## Cam fix for LG G6 and delete some line cause im stupid.
cd frameworks/base/
git fetch https://github.com/xc112lg/android_frameworks_base-1.git patch-17
git cherry-pick a245af744209ccb9cb6ad6981f181fa8a9ba65c5
cd ../../

# Settings Fix
cd packages/apps/Settings
git fetch https://github.com/xc112lg/packages_apps_Settings.git evo
git cherry-pick 12a6a70be4970c8b08d1ca07ad422752c636ef33
cd ../../../

