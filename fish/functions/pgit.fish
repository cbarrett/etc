function --wraps git --description "execute git commands on git repo in guilt's patches dir" pgit 
    git -C (git rev-parse --git-dir)/patches $argv
end

