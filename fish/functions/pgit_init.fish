function pgit_init --description "initialize git repo in guilt's patches directory"
    set git_dir (git rev-parse --git-dir)
    if not test $status -eq 0 -a -d $git_dir
        return 1
    end
    set patches $git_dir/patches
    if not test -d $patches
        echo "*** guilt not initialized" >&2
        return 1
    end
    
    git init $patches
    # Used to track which patches are currently applied and what guards are active
    echo '**/status' > $patches/.gitignore
    echo '**/gaurds' >> $patches/.gitignore
    # When refreshing, guilt saves a backup of the patch; ignore those
    echo '*~' >> $patches/.gitignore
    git -C $patches add .gitignore
end

