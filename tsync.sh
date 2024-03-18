#!/bin/bash

# Sync repositories and capture the output
output=\\$(repo sync -c -j\\$(nproc --all) --force-sync --no-clone-bundle --no-tags 2>&1)
if echo "\\$output" | grep -q "Failing repos:"; then
    while IFS= read -r line; do
        repo_info=\\$(echo "\\$line" | awk -F': ' '{print \\$NF}')
        repo_path=\\$(dirname "\\$repo_info")
        repo_name=\\$(basename "\\$repo_info")
        rm -rf "\\$repo_path/\\$repo_name"
    done <<< "\\$(echo "\\$output" | awk '/Failing repos:/ {flag=1; next} /Repo command failed due to the following `SyncError` errors:/ {flag=0} flag')"
    repo sync -c -j\\$(nproc --all) --force-sync --no-clone-bundle --no-tags
else
    echo "All repositories synchronized successfully."
fi

echo "\\$sync">> craverun.sh





echo '#!/bin/bash' > craverun.sh
echo 'output=\$(repo sync -c -j\$(nproc --all) --force-sync --no-clone-bundle --no-tags 2>&1)' >> craverun.sh
echo 'if echo "\$output" | grep -q "Failing repos:"; then' >> craverun.sh
echo '    while IFS= read -r line; do' >> craverun.sh
echo '        repo_info=\$(echo "\$line" | awk -F": " "{print \\$NF}")' >> craverun.sh
echo '        repo_path=\$(dirname "\$repo_info")' >> craverun.sh
echo '        repo_name=\$(basename "\$repo_info")' >> craverun.sh
echo '        rm -rf "\$repo_path/\$repo_name"' >> craverun.sh
echo '    done <<< "\$(echo "\$output" | awk "/Failing repos:/ {flag=1; next} /Repo command failed due to the following \`SyncError\` errors:/ {flag=0} flag")"' >> craverun.sh
echo '    repo sync -c -j\$(nproc --all) --force-sync --no-clone-bundle --no-tags' >> craverun.sh
echo 'else' >> craverun.sh
echo '    echo "All repositories synchronized successfully."' >> craverun.sh
echo 'fi' >> craverun.sh

