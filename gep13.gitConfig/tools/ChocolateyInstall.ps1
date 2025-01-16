git config --global "user.name" "Gary Ewan Park"
git config --global "user.email" "gep13@gep13.co.uk"

# Only enable this is you want signing of commits
# git config --global user.signingkey 5BE9DB14
# git config --global commit.gpgsign true
# Windows
# git config --global "gpg.program" "C:/Program Files (x86)/GNU/GnuPG/pub/gpg.exe"
# Mac
# On a Mac, the path to the gpg program isn't required, as this is already on the path

git config --global "push.default" "simple"

git config --global "diff.tool" "vscode"
git config --global "difftool.vscode.cmd" "code --wait --diff $LOCAL $REMOTE"

git config --global "merge.ff" "false"
git config --global "merge.log" "true"
git config --global "merge.renamelimit" "6500"
git config --global "merge.tool" "kdiff3"

# Windows
git config --global "mergetool.kdiff3.path" "C:/Program Files/KDiff3/bin/kdiff3.exe"

git config --global "mergetool.kdiff3.keepBackup" "false"
git config --global "mergetool.kdiff3.trustExitCode" "false"

git config --global "fetch.prune" "true"

git config --global "core.symlinks" "false"
git config --global "core.autocrlf" "false"
git config --global "core.editor" "code --wait"

git config --global "alias.st" "status"
git config --global "alias.standup" "!git log --since yesterday --oneline --author 'gep13@gep13.co.uk'"
git config --global "alias.lg" "log --pretty=format:'%C(yellow)%h%C(reset) %s %C(cyan)%cr%C(reset) %C(blue)%an%C(reset) %C(green)%d%C(reset)' --graph --date-order"
git config --global "alias.review" "log -p --reverse -M -C -C --patience --no-prefix"

git config --global "color.branch" "auto"
git config --global "color.diff" "auto"
git config --global "color.status" "auto"
git config --global "color.ui" "auto"
