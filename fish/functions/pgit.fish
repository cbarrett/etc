function pgit --wraps git --description "execute git commands on git repo in guilt's patches dir" 
    git -C (git rev-parse --git-dir)/patches $argv
end

