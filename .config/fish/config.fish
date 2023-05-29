if status is-interactive
    # Commands to run in interactive sessions can go here

end
        set -x LC_ALL en_US.UTF-8
        set -x LC_CTYPE en_US.UTF-8
source (/usr/bin/starship init fish --print-full-init | psub)


