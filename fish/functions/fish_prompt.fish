function fish_prompt --description 'Write out the prompt'
	set -l last_status $status

	if not set -q __fish_prompt_normal
		set -g __fish_prompt_normal (set_color normal)
	end

        if not set -q __fish_prompt_hostname
            set -g __fish_prompt_hostname (hostname | cut -d . -f 1)
        end

	# PWD
	set_color $fish_color_cwd
        echo -n (prompt_pwd)
        set_color normal 

        if set -q SSH_CONNECTION
            echo -n -s "@$__fish_prompt_hostname" 
        end

	printf '%s ' (__fish_git_prompt)

        if test (whoami) != "cbarrett"
            echo -n (whoami)
        end
	
        if not test $last_status -eq 0
            set_color $fish_color_error
	end

	echo -n '$ '

	set_color normal
end

