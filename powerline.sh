#!/bin/bash

readonly COLOR_FG_WHITE="$(tput setaf 7)"
readonly COLOR_FG_GRAY="$(tput setaf 8)"
readonly COLOR_FG_FAILURE="$(tput setaf 1)"
readonly COLOR_FG_SUCCESS="$(tput setaf 5)"
readonly COLOR_FG="$(tput setaf 0)"
readonly COLOR_BG_FAILURE="$(tput setab 1)"
readonly COLOR_BG_SUCCESS="$(tput setab 5)"
readonly COLOR_BG="$(tput setab 7)"
readonly COLOR_RESET="$(tput sgr0)"

__join() {
    local sep="$1"
    shift
    local len=$#
    local args=("$@")
    for ((i=0; i<$len; i++)); do
        test $i -ne 0 && echo -n "$sep"
        echo -n "${args[$i]}"
    done
}

__ps1() {
    local ret=$?
    local state_bg
    local state_fg
    if [ $ret -eq 0 ]; then
        state_fg="$COLOR_FG_SUCCESS"
        state_bg="$COLOR_BG_SUCCESS"
    else
        state_fg="$COLOR_FG_FAILURE"
        state_bg="$COLOR_BG_FAILURE"
    fi
    local __pwd="$PWD"
    [[ "$__pwd" =~ ^"$HOME"(/|$) ]] && __pwd="${__pwd/#$HOME/\~}"
    IFS="/" read -r -a __pwd <<< "$__pwd"
    test "${__pwd[0]}" = "" && __pwd[0]="/"
    PS1="\[\e]0;\w\a\]"
    PS1+="\n"
    PS1+="\[$COLOR_FG$COLOR_BG\]"
    PS1+=" $(__join " \[$COLOR_FG_GRAY\]"$'\uE0B1'"\[$COLOR_FG\] " "${__pwd[@]}") "
    PS1+="\[$COLOR_FG_WHITE$state_bg\]"$'\uE0B0'"\[$COLOR_FG\]"
    PS1+=" $ "
    PS1+="\[$COLOR_RESET$state_fg\]"$'\uE0B0'
    PS1+="\[$COLOR_RESET\] "
    return $ret
}
PROMPT_COMMAND=__ps1
