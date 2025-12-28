function __git_info
    command git rev-parse --is-inside-work-tree >/dev/null 2>&1; or return

    set -l branch (command git symbolic-ref --short HEAD 2>/dev/null \
        || command git rev-parse --short HEAD 2>/dev/null)

    command git diff --quiet --ignore-submodules HEAD >/dev/null 2>&1
    or set -l dirty '*'

    echo "$branch$dirty"
end

function fish_right_prompt
    set -g fish_prompt_pwd_dir_length 3

    set_color blue
    echo -n (prompt_pwd)
    set_color normal

    set -l git (__git_info)
    test -n "$git"; and echo -n " $git"
end
