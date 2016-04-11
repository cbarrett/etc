function pgit_dir --description "print's the location of guilt's patches repository"
    set -l git_dir (git rev-parse --git-dir)
    if not test $status -eq 0 -a -d $git_dir
        return 1
    end
    set -l patches $git_dir/patches
    if not test -d $patches
        echo "*** guilt not initialized" >&2
        return 1
    end
    echo $patches
end
