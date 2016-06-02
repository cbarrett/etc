function --description "prints the location of the guilt repo subdirectory for the current branch" pgit_branch
    set -l patches (pgit_dir)
    if not test $status -eq 0
        return 1
    end
    set -l name (git rev-parse --abbrev-ref HEAD)
    if not test $status -eq 0 
        return 1
    end
    if not test -d "$patches/$name"
        echo "*** guilt not initialized for this branch" >&2
        return 1
    end
    echo $patches/$name
end
