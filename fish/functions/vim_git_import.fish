# Run this in the directory you want the subtrees to be located in
# Takes the name of the plugin's directory 
function vim_git_import --description 'Imports vim plugins to git subtrees' --argument plugin
  if test (count $argv) -ne 1
    echo "usage: vim_git_import PLUGIN"
    return 1
  end
  set -l prefix (git rev-parse --show-prefix)$plugin
  set -l url (pushd $plugin; git remote -v | head -n 1 | cut -f 2 | cut -d ' ' -f 1; popd)
  pushd (git rev-parse --show-toplevel)
  echo  "git subtree add --prefix $prefix --squash $url master"
  # git subtree add --prefix $prefix --squash $url master
  popd
end
