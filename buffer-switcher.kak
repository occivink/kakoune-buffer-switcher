# we assume that a buffer name will never contain newlines (not exactly true, but who cares)

face global BufferSwitcherCurrent black,green

define-command buffer-switcher %{
    try %{
        b *buffer-switcher*
    } catch %{
        eval -save-regs '"/' %{
            reg / "^\Q%val{bufname}\E$"
            reg dquote %val{buflist}

            edit -scratch *buffer-switcher*
            exec '<a-P>)<a-,>i<ret><esc>'
            exec '%<a-s>'
            # remove *debug* buffer
            exec -draft '<a-k>^\*debug\*$<ret>d'
            try %{
                # select current one
                exec '<a-k><ret>'
                # also highlight it in green
                addhl buffer/ regex "%reg{/}" 0:BufferSwitcherCurrent
            } catch %{
                exec gg
            }
            map buffer normal <ret> ': buffer-switcher-switch<ret>'
            map buffer normal <esc> ': delete-buffer *buffer-switcher*<ret>'
            hook global WinDisplay -once .* %{ try %{ delete-buffer *buffer-switcher* } }
        }
    }
}

define-command -hidden buffer-switcher-switch %{
    try buffer-switcher-delete-buffers
    try buffer-switcher-sort-buffers
    exec ',;xH'
    buffer %val{selection}
    try %{ delete-buffer *buffer-switcher* }
}

# delete all buffers whose lines were removed
define-command -hidden buffer-switcher-delete-buffers %{
    # print buflist, and all lines
    # everything that appears only once gets removed
    eval -buffer *buffer-switcher* %{
        exec '%<a-s>H'
        eval %sh{
            {
            eval set -- "$kak_quoted_buflist"
            for buf do
                # ignore self and debug
                if [ "$buf" = '*buffer-switcher*' ]; then
                    :
                elif [ "$buf" = '*debug*' ]; then
                    :
                else
                    printf '%s\n' "$buf"
                fi
            done
            eval set -- "$kak_quoted_selections"
            for buf do
                printf '%s\n' "$buf"
            done
            } | awk "
                // {
                    line=\$0
                    if (line in line_count)
                        line_count[line] = line_count[line] + 1;
                    else
                        line_count[line] = 1;
                }
                END {
                    for (line in line_count)
                        if (line_count[line] == 1)
                        {
                            gsub(\"'\", \"''''\", line);
                            print(\"try 'delete-buffer ''\" line \"'' '\");
                        }
                }"
        }
    }
}

# re-arrange the buflist according to the order in the *buffer-switcher*
define-command -hidden buffer-switcher-sort-buffers %{
    eval -buffer *buffer-switcher* %{
        exec '%<a-s>H'
        arrange-buffers %val{selections}
    }
}
