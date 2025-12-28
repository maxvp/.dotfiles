function fish_prompt
    set -l last_status $status

    test $last_status -ne 0; and set_color red; or set_color normal
    echo -n "λ "
    set_color normal
end
