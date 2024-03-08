## Cam fix for LG G6 and delete some line cause im stupid.
cd frameworks/base/
git fetch https://github.com/xc112lg/frameworks_base.git evo
sleep 1 &&git cherry-pick 39c4fa1501de6346603419427782d406c0dcc05f
sleep 1 &&git cherry-pick e294b96733fe90f4235ec2abd7e3f2efc2ab2430
sleep 1 &&git cherry-pick 2400aeaac60582149dde363ca7fdf6718392f977
sleep 1 &&git cherry-pick 095d9a49fa18ff1ac7e032091f270cd1e7c4a340 670f5c811a4217d5e311d62677d45a80d1272bd4
cd ../../

# Settings Fix
cd packages/apps/Settings
git fetch https://github.com/xc112lg/packages_apps_Settings.git evo
git cherry-pick 12a6a70be4970c8b08d1ca07ad422752c636ef33
cd ../../../


