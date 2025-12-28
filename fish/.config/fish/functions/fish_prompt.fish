# ~/.dotfiles/fish/.config/fish/functions/fish_prompt.fish

function fish_prompt
    set -l last_status $status

    # Configure the internal git prompt behavior
    set -g fish_prompt_pwd_dir_length 3

    echo 
    set_color blue
    echo -n (prompt_pwd)
    set_color normal

    # Use the high-performance internal git prompt
    printf '%s ' (fish_vcs_prompt)

    echo
    test $last_status -ne 0; and set_color red; or set_color normal
    echo -n "λ "
    set_color normal
end
