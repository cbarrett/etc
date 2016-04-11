function pgit_init --description "initialize git repo in guilt's patches directory"
    set -l patches (pgit_dir)
    if not test $status -eq 0
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

