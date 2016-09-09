function browser -a file
    if test -z "$file"
        echo "browser: usage: browser [url | path]"  
        return 1
    end
    if not set -q SSH_CONNECTION
        open $file
        return $status
    end

    set -l mac (echo $SSH_CONNECTION | cut -f 1 -d ' ')
    set -l rdo "ssh cbarrett@$mac"

    # TODO test if we can connect so the script doesn't just hang indefinitely

    if string match -q -i -r '^https?://' $file
        eval $rdo open $file
        return $status
    end

    set file (string replace -i -r '^file://' '' $file)

    if test -e $file 
        set -l tmp (eval $rdo mktemp -d -t browser)
        set -l rpath $tmp/(basename $file)
        scp -q $file cbarrett@$mac:$rpath
        eval $rdo open $rpath
        return $status
    else
        echo "browser: $file: No such file or directory" >&2
        return 1 
    end
end
