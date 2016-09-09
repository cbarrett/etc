function browser -a file
    if test -z "$file"
        echo "browser: usage: browser [url | path]" >&2
        return 1
    end

    # If we're not connected via SSH, try running open(1)
    if not set -q SSH_CONNECTION
        open $file
        return $status
    end

    # SSH_CONNECTION contains the IP of the client machine 
    set -l mac (echo $SSH_CONNECTION | cut -f 1 -d ' ')
    set -l rdo "ssh cbarrett@$mac"

    # TODO test if we can connect so the script doesn't just hang indefinitely

    # If we get an http URL, we're done. Run open(1) on the Mac to open it
    if string match -q -i -r '^https?://' $file
        eval $rdo open $file
        return $status
    end

    # Strip file:// prefix
    set file (string replace -i -r '^file://' '' $file)

    if test ! -e $file
        echo "browser: $file: No such file or directory" >&2
        return 1
    end

    # Create a temporary directory on the Mac, and copy the HTML file to display into it. Then run open(1) on it
    set -l tmp (eval $rdo mktemp -d -t browser)
    set -l rpath $tmp/(basename $file)
    scp -q $file cbarrett@$mac:$rpath
    eval $rdo open $rpath
end
