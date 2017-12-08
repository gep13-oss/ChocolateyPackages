git config --global "user.name" "Gary Ewan Park"
git config --global "user.email" "gep13@gep13.co.uk"

git config --global "push.default" "simple"

git config --global "diff.tool" "vscode"
git config --global "difftool.vscode.cmd" "code --wait --diff $LOCAL $REMOTE"
git config --global core.editor "code --wait"

git config --global "merge.ff" "false"
git config --global "merge.log" "true"
git config --global "merge.renamelimit" "6500"

git config --global "merge.tool" "kdiff3"

# Windows
git config --global "mergetool.kdiff3.path" "C:/Program Files/KDiff3/kdiff3.exe"

# Mac
git config --global "mergetool.kdiff.cmd" "/Applications/kdiff3.app/Contents/MacOS/kdiff3"
git config --global "mergetool.kdiff.args" "$base $local $other -o $output"

git config --global "mergetool.kdiff3.keepBackup" "false"
git config --global "mergetool.kdiff3.trustExitCode" "false"

git config --global "fetch.prune" "true"

git config --global "core.symlinks" "false"
git config --global "core.autocrlf" "false"
git config --global "core.editor" "code --wait"

git config --global user.signingkey 5BE9DB14
git config --global commit.gpgsign true
git config --global "gpg.program" "C:/Program Files (x86)/GNU/GnuPG/pub/gpg.exe"
