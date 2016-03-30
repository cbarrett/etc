function pgit_init --description "initialize git repo in guilt's patches directory"
    pushd (git rev-parse --git-dir)/patches
    git init
    echo \
    '**/status
    **/gaurds' > .gitignore
    popd 
end

