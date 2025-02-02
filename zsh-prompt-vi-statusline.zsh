#!/usr/env zsh

# +----------------+
# | Cursor Options |
# +----------------+

# Grabbed from this post: https://unix.stackexchange.com/q/433273
local _beam_cursor() {
    echo -ne '\e[5 q'
}
local _block_cursor() {
    echo -ne '\e[1 q'
}

local _cursor_select() {
    if [[ "$KEYMAP" == "main"
        || "$KEYMAP" == "viins"
        || "$KEYMAP" == "isearch"
    ]]; then
        _beam_cursor
    else
        _block_cursor
    fi
}

# Catppuccin Mocha
viinsert='%F{#a6e3a1}%B%S I %s%b%f'
vicommand='%F{#89b4fa}%B%S N %s%b%f'
vivisual='%F{#cba6f7}%B%S V %s%b%f'
vireplace='%F{#f9e2af}%B%S R %s%b%f'

export VI_MODE="$viinsert"

local _vi_mode() {
    # Source: https://www.reddit.com/r/zsh/comments/krwm0t/im_looking_for_a_way_to_display_vi_visual_and/
    #
    # INFO: Uncomment for debug info
    #zle -M "$KEYMAP : $ZLE_STATE = $VI_MODE"
    case "$KEYMAP$ZLE_STATE" in
        (vicmd*|command*)
            # Default
            export VI_MODE="$vicommand"
            _block_cursor
            ;;
        (visual*)
            # From $KEYMAP
            export VI_MODE="$vivisual"
            _block_cursor
            ;;
        (*overwrite*)
            # Set by $ZLE_STATE
            export VI_MODE="$vireplace"
            _block_cursor
            ;;
        (viins*|main*)
            # From $ZLE_STATE
            export VI_MODE="$viinsert"
            _beam_cursor
            ;;
    esac
    zle reset-prompt

}

local _line_init() {
    # start in viins
    zle -K viins
}

zle -N zle-keymap-select _vi_mode
zle -N zle-line-init _line_init

###
# Example for use in a prompt

# enable colored prompts
# autoload -U promptinit && promptinit

# PROMPT='${VI_MODE} -> '


