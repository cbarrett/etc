# Run this in the directory you want the subtrees to be located in
# Takes the path to the directory where the plugins are, usually ~/.vim/bundle
# Can be passed a blacklist by adding "--except NAME..." to the arguments. Useful for segregating plugins into different directories
function vim_git_import --description 'Imports ~/.vim/bundle plugins to git subtrees' --argument from
    set -l exceptions
    if test (count $argv) -eq 0     
        echo "usage: vim_git_import FROM [--except NAME...]"
        return 1
    else if test (count $argv) -ge 2
        if test $argv[2] != "--except"
            echo "usage: vim_git_import FROM [--except NAME...]"
            return 1
        end
        set exceptions $argv[3..(count $argv)]
    end
    for plugin in (find $from -maxdepth 1 | tail -n +2)
        set -l plugin_name (basename $plugin)
        if contains $plugin_name $exceptions
            continue
        end
        set -l prefix (git rev-parse --show-prefix)$plugin_name
        set -l url (pushd $plugin; git remote -v | head -n 1 | cut -f 2 | cut -d ' ' -f 1; popd)
        pushd (git rev-parse --show-toplevel)
            # echo  "git subtree add --prefix $prefix --squash $url master"
            git subtree add --prefix $prefix --squash $url master; read _
        popd
    end
end
