#!/usr/bin/env bash
# vim: ft=bash ts=2 sw=2 sts=2
#
# agnoster's Theme - https://gist.github.com/3712874
# A Powerline-inspired theme for BASH
#
# (Converted from ZSH theme by Kenny Root)
# https://gist.github.com/kruton/8345450
#
# Updated & fixed by Erik Selberg erik@selberg.org 1/14/17
# Tested on MacOSX, Ubuntu, Amazon Linux
# Bash v3 and v4
#
# # README
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://gist.github.com/1595572).
# I recommend: https://github.com/powerline/fonts.git
# > git clone https://github.com/powerline/fonts.git fonts
# > cd fonts
# > install.sh

# In addition, I recommend the
# [Solarized theme](https://github.com/altercation/solarized/) and, if you're
# using it on Mac OS X, [iTerm 2](http://www.iterm2.com/) over Terminal.app -
# it has significantly better color fidelity.

# Install:

# I recommend the following:
# $ cd home
# $ mkdir -p .bash/themes/agnoster-bash
# $ git clone https://github.com/speedenator/agnoster-bash.git .bash/themes/agnoster-bash

# then add the following to your .bashrc:

# export THEME=$HOME/.bash/themes/agnoster-bash/agnoster.bash
# if [[ -f $THEME ]]; then
#     export DEFAULT_USER=`whoami`
#     source $THEME
# fi

#
# # Goals
#
# The aim of this theme is to only show you *relevant* information. Like most
# prompts, it will only show git information when in a git working directory.
# However, it goes a step further: everything from the current user and
# hostname to whether the last call exited with an error to whether background
# jobs are running in this shell will all be displayed automatically when
# appropriate.

# Generally speaking, this script has limited support for right
# prompts (ala powerlevel9k on zsh), but it's pretty problematic in Bash.
# The general pattern is to write out the right prompt, hit \r, then
# write the left. This is problematic for the following reasons:
# - Doesn't properly resize dynamically when you resize the terminal
# - Changes to the prompt (like clearing and re-typing, super common) deletes the prompt
# - Getting the right alignment via columns / tput cols is pretty problematic (and is a bug in this version)
# - Bash prompt escapes (like \h or \w) don't get interpolated
#
# all in all, if you really, really want right-side prompts without a
# ton of work, recommend going to zsh for now. If you know how to fix this,
# would appreciate it!

# note: requires bash v4+... Mac users - you often have bash3.
# 'brew install bash' will set you free
PROMPT_DIRTRIM=2 # bash4 and above

######################################################################
DEBUG=0
debug() {
    if [[ ${DEBUG} -ne 0 ]]; then
        >&2 echo -e $*
    fi
}

######################################################################
### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

CURRENT_BG='NONE'
CURRENT_RBG='NONE'
SEGMENT_SEPARATOR=''
RIGHT_SEPARATOR=''
LEFT_SUBSEG=''
RIGHT_SUBSEG=''

COLOR_0=''
COLOR_1=''
COLOR_2=''
COLOR_3=''
COLOR_LINE_0=''
COLOR_LINE_1=''
COLOR_LINE_2=''
COLOR_LINE_3=''
# Define the function with four variables as arguments



text_effect() {
    case "$1" in
        reset)      echo 0;;
        bold)       echo 1;;
        underline)  echo 4;;
    esac
}

# to add colors, see
# http://bitmote.com/index.php?post/2012/11/19/Using-ANSI-Color-Codes-to-Colorize-Your-Bash-Prompt-on-Linux
# under the "256 (8-bit) Colors" section, and follow the example for orange below
fg_color() {
    case "$1" in
        black)       echo 30;;
        red)         echo 31;;
        green)       echo 32;;
        yellow)      echo 33;;
        blue)        echo 34;;
        magenta)     echo 35;;
        cyan)        echo 36;;
        white)       echo 37;;
        orange)      echo 38\;5\;166;;
        GreenUser0)  echo 38\;2\;6\;27\;15;;
        GreenUser1)  echo 38\;2\;20\;90\;50;;		
        GreenUser2)  echo 38\;2\;34\;153\;84;;	
        GreenUser3)  echo 38\;2\;125\;206\;160;;
		GreenLine0)  echo 38\;2\;177\;201\;161;;
		GreenLine1)  echo 38\;2\;211\;221\;206;;
		GreenLine2)  echo 38\;2\;236\;242\;234;;
		GreenLine3)  echo 38\;2\;249\;248\;242;;
        PurpleUser0) echo 38\;2\;36\;9\;37;;
        PurpleUser1) echo 38\;2\;72\;19\;75;;
        PurpleUser2) echo 38\;2\;90\;42\;93;;
        PurpleUser3) echo 38\;2\;145\;113\;147;;
		PurpleLine0) echo 38\;2\;131\;98\;139;;
		PurpleLine1) echo 38\;2\;174\;152\;183;;
		PurpleLine2) echo 38\;2\;206\;191\;211;;
		PurpleLine3) echo 38\;2\;233\;228\;235;;
        RedUser0) echo 38\;2\;127\;0\;0;;
        RedUser1) echo 38\;2\;178\;0\;0;;
        RedUser2) echo 38\;2\;185\;25\;25;;
        RedUser3) echo 38\;2\;201\;76\;76;;
        RedLine0) echo 38\;255\;241\;236;;
		RedLine1) echo 38\;255\;224\;221;;
		RedLine2) echo 38\;255\;205\;205;;
		RedLine3) echo 38\;255\;187\;187;;
        PinkUser0) echo 38\;2\;124\;0\;124;;
        PinkUser1) echo 38\;2\;178\;0\;178;;
        PinkUser2) echo 38\;2\;193\;50\;193;;
        PinkUser3) echo 38\;2\;216\;127\;216;;
		PinkLine0) echo 38\;2\;191\;97\;155;;
		PinkLine1) echo 38\;2\;219\;158\;201;;
		PinkLine2) echo 38\;2\;235\;196\;222;;
		PinkLine3) echo 38\;2\;244\;223\;233;;
        OrangeUser0) echo 38\;2\;153\;76\;0;;
        OrangeUser1) echo 38\;2\;204\;102\;0;;
        OrangeUser2) echo 38\;2\;229\;115\;0;;
        OrangeUser3) echo 38\;2\;255\;140\;25;;
		OrangeLine0) echo 38\;2\;205\;148\;100;;
		OrangeLine1) echo 38\;2\;242\;211\;156;;
		OrangeLine2) echo 38\;2\;249\;235\;206;;
		OrangeLine3) echo 38\;2\;253\;246\;232;;
        YellowUser0) echo 38\;2\;153\;153\;0;;
        YellowUser1) echo 38\;2\;178\;178\;0;;
        YellowUser2) echo 38\;2\;229\;229\;0;;
        YellowUser3) echo 38\;2\;229\;229\;127;;
        YellowLine0) echo 38\;2\;127\;127\;229;;
		YellowLine1) echo 38\;2\;88\;88\;160;;
		YellowLine2) echo 38\;2\;44\;44\;80;;
		YellowLine3) echo 38\;2\;13\;13\;24;;
        BlueUser0) echo 38\;2\;0\;0\;91;;
        BlueUser1) echo 38\;2\;0\;0\;153;;
        BlueUser2) echo 38\;2\;76\;76\;183;;
        BlueUser3) echo 38\;2\;153\;153\;214;;
        BlueLine0) echo 38\;2\;245\;245\;245;;
		BlueLine1) echo 38\;2\;240\;240\;240;;
		BlueLine2) echo 38\;2\;235\;235\;235;;
		BlueLine3) echo 38\;2\;230\;230\;230;;
        GrayUser0) echo 38\;2\;48\;48\;48;;
        GrayUser1) echo 38\;2\;86\;86\;86;;
        GrayUser2) echo 38\;2\;119\;119\;119;;
        GrayUser3) echo 38\;2\;159\;159\;159;;
        GrayLine0) echo 38\;2\;240\;240\;240;;
		GrayLine1) echo 38\;2\;235\;235\;235;;
		GrayLine2) echo 38\;2\;230\;230\;230;;
		GrayLine3) echo 38\;2\;225\;225\;225;;
    esac
}

bg_color() {
    case "$1" in
        black)       echo 40;;
        red)         echo 41;;
        green)       echo 42;;
        yellow)      echo 43;;
        blue)        echo 44;;
        magenta)     echo 45;;
        cyan)        echo 46;;
        white)       echo 47;;
        orange)      echo 48\;2\;166;;
        GreenUser0)  echo 48\;2\;6\;27\;15;;
        GreenUser1)  echo 48\;2\;20\;90\;50;;
        GreenUser2)  echo 48\;2\;34\;153\;84;;
        GreenUser3)  echo 48\;2\;125\;206\;160;;
        GreenLine0)  echo 48\;2\;177\;201\;161;;
		GreenLine1)  echo 48\;2\;211\;221\;206;;
		GreenLine2)  echo 48\;2\;236\;242\;234;;
		GreenLine3)  echo 48\;2\;249\;248\;242;;
        PurpleUser0) echo 48\;2\;36\;9\;37;;
        PurpleUser1) echo 48\;2\;72\;19\;75;;
        PurpleUser2) echo 48\;2\;90\;42\;93;;
        PurpleUser3) echo 48\;2\;145\;113\;147;;
        PurpleLine0) echo 38\;2\;131\;98\;139;;
		PurpleLine1) echo 38\;2\;174\;152\;183;;
		PurpleLine2) echo 38\;2\;206\;191\;211;;
		PurpleLine3) echo 38\;2\;233\;228\;235;;
        RedUser0) echo 48\;2\;127\;0\;0;;
        RedUser1) echo 48\;2\;178\;0\;0;;
        RedUser2) echo 48\;2\;185\;25\;25;;
        RedUser3) echo 48\;2\;201\;76\;76;;
        RedLine0) echo 48\;255\;241\;236;;
		RedLine1) echo 48\;255\;224\;221;;
		RedLine2) echo 48\;255\;205\;205;;
		RedLine3) echo 48\;255\;187\;187;;
        PinkUser0) echo 48\;2\;124\;0\;124;;
        PinkUser1) echo 48\;2\;178\;0\;178;;
        PinkUser2) echo 48\;2\;193\;50\;193;;
        PinkUser3) echo 48\;2\;216\;127\;216;;
        PinkLine0) echo 48\;2\;191\;97\;155;;
		PinkLine1) echo 48\;2\;219\;158\;201;;
		PinkLine2) echo 48\;2\;235\;196\;222;;
		PinkLine3) echo 48\;2\;244\;223\;233;;
        OrangeUser0) echo 48\;2\;153\;76\;0;;
        OrangeUser1) echo 48\;2\;204\;102\;0;;
        OrangeUser2) echo 48\;2\;229\;115\;0;;
        OrangeUser3) echo 48\;2\;255\;140\;25;;
		OrangeLine0) echo 48\;2\;205\;148\;100;;
		OrangeLine1) echo 48\;2\;242\;211\;156;;
		OrangeLine2) echo 48\;2\;249\;235\;206;;
		OrangeLine3) echo 48\;2\;253\;246\;232;;
        YellowUser0) echo 48\;2\;153\;153\;0;;
        YellowUser1) echo 48\;2\;178\;178\;0;;
        YellowUser2) echo 48\;2\;229\;229\;0;;
        YellowUser3) echo 48\;2\;229\;229\;127;;
        YellowLine0) echo 48\;2\;127\;127\;229;;
		YellowLine1) echo 48\;2\;88\;88\;160;;
		YellowLine2) echo 48\;2\;44\;44\;80;;
		YellowLine3) echo 48\;2\;13\;13\;24;;
        BlueUser0) echo 48\;2\;0\;0\;91;;
        BlueUser1) echo 48\;2\;0\;0\;153;;
        BlueUser2) echo 48\;2\;76\;76\;183;;
        BlueUser3) echo 48\;2\;153\;153\;214;;
        BlueLine0) echo 48\;2\;245\;245\;245;;
		BlueLine1) echo 48\;2\;240\;240\;240;;
		BlueLine2) echo 48\;2\;235\;235\;235;;
		BlueLine3) echo 48\;2\;230\;230\;230;;
        GrayUser0) echo 48\;2\;48\;48\;48;;
        GrayUser1) echo 48\;2\;86\;86\;86;;
        GrayUser2) echo 48\;2\;119\;119\;119;;
        GrayUser3) echo 48\;2\;159\;159\;159;;
        GrayLine0) echo 48\;2\;240\;240\;240;;
		GrayLine1) echo 48\;2\;235\;235\;235;;
		GrayLine2) echo 48\;2\;230\;230\;230;;
		GrayLine3) echo 48\;2\;225\;225\;225;;
    esac;
}

# TIL: declare is global not local, so best use a different name
# for codes (mycodes) as otherwise it'll clobber the original.
# this changes from BASH v3 to BASH v4.
ansi() {
    local seq
    declare -a mycodes=("${!1}")

    debug "ansi: ${!1} all: $* aka ${mycodes[@]}"

    seq=""
    for ((i = 0; i < ${#mycodes[@]}; i++)); do
        if [[ -n $seq ]]; then
            seq="${seq};"
        fi
        seq="${seq}${mycodes[$i]}"
    done
    debug "ansi debug:" '\\[\\033['${seq}'m\\]'
    echo -ne '\[\033['${seq}'m\]'
    # PR="$PR\[\033[${seq}m\]"
}

ansi_single() {
    echo -ne '\[\033['$1'm\]'
}

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
    local bg fg
    declare -a codes

    debug "Prompting $1 $2 $3"

    # if commented out from kruton's original... I'm not clear
    # if it did anything, but it messed up things like
    # prompt_status - Erik 1/14/17

    #    if [[ -z $1 || ( -z $2 && $2 != default ) ]]; then
    codes=("${codes[@]}" $(text_effect reset))
    #    fi
    if [[ -n $1 ]]; then
        bg=$(bg_color $1)
        codes=("${codes[@]}" $bg)
        debug "Added $bg as background to codes"
    fi
    if [[ -n $2 ]]; then
        fg=$(fg_color $2)
        codes=("${codes[@]}" $fg)
        debug "Added $fg as foreground to codes"
    fi

    debug "Codes: "
    # declare -p codes

    if [[ $CURRENT_BG != NONE && $1 != $CURRENT_BG ]]; then
        declare -a intermediate=($(fg_color $CURRENT_BG) $(bg_color $1))
        debug "pre prompt " $(ansi intermediate[@])
        PR="$PR $(ansi intermediate[@])$SEGMENT_SEPARATOR"
        debug "post prompt " $(ansi codes[@])
        PR="$PR$(ansi codes[@]) "
    else
        debug "no current BG, codes is $codes[@]"
        PR="$PR$(ansi codes[@]) "
    fi
    CURRENT_BG=$1
    [[ -n $3 ]] && PR="$PR$3"
}

# End the prompt, closing any open segments
prompt_end() {
    if [[ -n $CURRENT_BG ]]; then
        declare -a codes=($(text_effect reset) $(fg_color $CURRENT_BG))
        PR="$PR $(ansi codes[@])$SEGMENT_SEPARATOR"
    fi
    declare -a reset=($(text_effect reset))
    PR="$PR $(ansi reset[@])"
    CURRENT_BG=$1
}

### virtualenv prompt
prompt_virtualenv() {
    if [[ -n $VIRTUAL_ENV ]]; then
        color=cyan
        prompt_segment $color $PRIMARY_FG
        prompt_segment $color white "$(basename $VIRTUAL_ENV)"
    fi
}


### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I)
prompt_context() {
    local user=`whoami`

    if [[ $user == $DEFAULT_USER || $user != $DEFAULT_USER || -n $SSH_CLIENT ]]; then
        prompt_segment "$COLOR_2" "$COLOR_LINE_2" '\u' #"Adel" #"$user@\h"
    fi
}

# prints history followed by HH:MM, useful for remembering what
# we did previously
prompt_histdt() {
    prompt_segment black default "\! [\A]"
}


git_status_dirty() {
    dirty=$(git status -s 2> /dev/null | tail -n 1)
    [[ -n $dirty ]] && echo " ●"
}

git_stash_dirty() {
    stash=$(git stash list 2> /dev/null | tail -n 1)
    [[ -n $stash ]] && echo " ⚑"
}

# Git: branch/detached head, dirty status
prompt_git() {
    local ref dirty
    if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
        ZSH_THEME_GIT_PROMPT_DIRTY='±'
        dirty=$(git_status_dirty)
        stash=$(git_stash_dirty)
        ref=$(git symbolic-ref HEAD 2> /dev/null) \
            || ref="➦ $(git describe --exact-match --tags HEAD 2> /dev/null)" \
            || ref="➦ $(git show-ref --head -s --abbrev | head -n1 2> /dev/null)"
        if [[ -n $dirty ]]; then
            prompt_segment yellow black
        else
            prompt_segment green black
        fi
        PR="$PR${ref/refs\/heads\// }$stash$dirty"
    fi
}

# Mercurial: clean, modified and uncomitted files
prompt_hg() {
    local rev st branch
    if $(hg id >/dev/null 2>&1); then
        if $(hg prompt >/dev/null 2>&1); then
            if [[ $(hg prompt "{status|unknown}") = "?" ]]; then
                # if files are not added
                prompt_segment red white
                st='±'
            elif [[ -n $(hg prompt "{status|modified}") ]]; then
                # if any modification
                prompt_segment yellow black
                st='±'
            else
                # if working copy is clean
                prompt_segment green black $CURRENT_FG
            fi
            PR="$PR$(hg prompt "☿ {rev}@{branch}") $st"
        else
            st=""
            rev=$(hg id -n 2>/dev/null | sed 's/[^-0-9]//g')
            branch=$(hg id -b 2>/dev/null)
            if `hg st | grep -q "^\?"`; then
                prompt_segment red white
                st='±'
            elif `hg st | grep -q "^[MA]"`; then
                prompt_segment yellow black
                st='±'
            else
                prompt_segment green black $CURRENT_FG
            fi
            PR="$PR☿ $rev@$branch $st"
        fi
    fi
}
# Host: current Hostname (useful for ssh)
prompt_host() {
    prompt_segment "$COLOR_1" "$COLOR_LINE_1" '\h'
}

# Dir: current working directory
prompt_dir() {
    prompt_segment "$COLOR_3" "$COLOR_LINE_3" '\w'
}


# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
    local symbols
    symbols=()
    [[ $RETVAL -ne 0 ]] && symbols+="$(ansi_single $(fg_color red))✘"
    [[ $UID != 0 ]] && symbols+="$(ansi_single $(fg_color $COLOR_LINE_0))$"
    [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="$(ansi_single $(fg_color cyan))⚙"

    [[ -n "$symbols" ]] && prompt_segment "$COLOR_0" "$COLOR_LINE_0" "$symbols"
}

change_colors() {
# Get the result of whoami command and redirect output to /dev/null
local user=$(hostname 2>/dev/null)

case $user in
vert)
COLOR_0="GreenUser0"
COLOR_1="GreenUser1"
COLOR_2="GreenUser2"
COLOR_3="GreenUser3"
COLOR_LINE_0="GreenLine0"
COLOR_LINE_1="GreenLine1"
COLOR_LINE_2="GreenLine2"
COLOR_LINE_3="GreenLine3"
;;
violet)
COLOR_0="PurpleUser0"
COLOR_1="PurpleUser1"
COLOR_2="PurpleUser2"
COLOR_3="PurpleUser3"
COLOR_LINE_0="PurpleLine0"
COLOR_LINE_1="PurpleLine1"
COLOR_LINE_2="PurpleLine2"
COLOR_LINE_3="PurpleLine3"
;;
rose)
COLOR_0="PinkUser0"
COLOR_1="PinkUser1"
COLOR_2="PinkUser2"
COLOR_3="PinkUser3"
COLOR_LINE_0="PinkLine0"
COLOR_LINE_1="PinkLine1"
COLOR_LINE_2="PinkLine2"
COLOR_LINE_3="PinkLine3"

;;
orange)
COLOR_0="OrangeUser0"
COLOR_1="OrangeUser1"
COLOR_2="OrangeUser2"
COLOR_3="OrangeUser3"
COLOR_LINE_0="OrangeLine0"
COLOR_LINE_1="OrangeLine1"
COLOR_LINE_2="OrangeLine2"
COLOR_LINE_3="OrangeLine3"
;;
bleu)
COLOR_0="BlueUser0"
COLOR_1="BlueUser1"
COLOR_2="BlueUser2"
COLOR_3="BlueUser3"
COLOR_LINE_0="BlueLine0"
COLOR_LINE_1="BlueLine1"
COLOR_LINE_2="BlueLine2"
COLOR_LINE_3="BlueLine3"
;;
jaune)
COLOR_0="YellowUser0"
COLOR_1="YellowUser1"
COLOR_2="YellowUser2"
COLOR_3="YellowUser3"
COLOR_LINE_0="YellowLine0"
COLOR_LINE_1="YellowLine1"
COLOR_LINE_2="YellowLine2"
COLOR_LINE_3="YellowLine3"
;;
bleu)
COLOR_0="BlueUser0"
COLOR_1="BlueUser1"
COLOR_2="BlueUser2"
COLOR_3="BlueUser3"
COLOR_LINE_0="BlueLine0"
COLOR_LINE_1="BlueLine1"
COLOR_LINE_2="BlueLine2"
COLOR_LINE_3="BlueLine3"
;;
root)
COLOR_0="RedUser0"
COLOR_1="RedUser1"
COLOR_2="RedUser2"
COLOR_3="RedUser3"
COLOR_LINE_0="RedLine0"
COLOR_LINE_1="RedLine1"
COLOR_LINE_2="RedLine2"
COLOR_LINE_3="RedLine3"ay
;;
*)
COLOR_0="GrayUser0"
COLOR_1="GrayUser1"
COLOR_2="GrayUser2"
COLOR_3="GrayUser3"
COLOR_LINE_0="GrayLine0"
COLOR_LINE_1="GrayLine1"
COLOR_LINE_2="GrayLine2"
COLOR_LINE_3="GrayLine3"
;;
esac
}

######################################################################
#
# experimental right prompt stuff
# requires setting prompt_foo to use PRIGHT vs PR
# doesn't quite work per above

rightprompt() {
    printf "%*s" $COLUMNS "$PRIGHT"
}

# quick right prompt I grabbed to test things.
__command_rprompt() {
    local times= n=$COLUMNS tz
    for tz in ZRH:Europe/Zurich PIT:US/Eastern \
              MTV:US/Pacific TOK:Asia/Tokyo; do
        [ $n -gt 40 ] || break
        times="$times ${tz%%:*}\e[30;1m:\e[0;36;1m"
        times="$times$(TZ=${tz#*:} date +%H:%M)\e[0m"
        n=$(( $n - 10 ))
    done
    [ -z "$times" ] || printf "%${n}s$times\\r" ''
}
# PROMPT_COMMAND=__command_rprompt

# this doens't wrap code in \[ \]
ansi_r() {
    local seq
    declare -a mycodes2=("${!1}")

    debug "ansi: ${!1} all: $* aka ${mycodes2[@]}"

    seq=""
    for ((i = 0; i < ${#mycodes2[@]}; i++)); do
        if [[ -n $seq ]]; then
            seq="${seq};"
        fi
        seq="${seq}${mycodes2[$i]}"
    done
    debug "ansi debug:" '\\[\\033['${seq}'m\\]'
    echo -ne '\033['${seq}'m'
    # PR="$PR\[\033[${seq}m\]"
}

# Begin a segment on the right
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_right_segment() {
    local bg fg
    declare -a codes

    debug "Prompt right"
    debug "Prompting $1 $2 $3"

    # if commented out from kruton's original... I'm not clear
    # if it did anything, but it messed up things like
    # prompt_status - Erik 1/14/17

    #    if [[ -z $1 || ( -z $2 && $2 != default ) ]]; then
    codes=("${codes[@]}" $(text_effect reset))
    #    fi
    if [[ -n $1 ]]; then
        bg=$(bg_color $1)
        codes=("${codes[@]}" $bg)
        debug "Added $bg as background to codes"
    fi
    if [[ -n $2 ]]; then
        fg=$(fg_color $2)
        codes=("${codes[@]}" $fg)
        debug "Added $fg as foreground to codes"
    fi

    debug "Right Codes: "
    # declare -p codes

    # right always has a separator
    # if [[ $CURRENT_RBG != NONE && $1 != $CURRENT_RBG ]]; then
    #     $CURRENT_RBG=
    # fi
    declare -a intermediate2=($(fg_color $1) $(bg_color $CURRENT_RBG) )
    # PRIGHT="$PRIGHT---"
    debug "pre prompt " $(ansi_r intermediate2[@])
    PRIGHT="$PRIGHT$(ansi_r intermediate2[@])$RIGHT_SEPARATOR"
    debug "post prompt " $(ansi_r codes[@])
    PRIGHT="$PRIGHT$(ansi_r codes[@]) "
    # else
    #     debug "no current BG, codes is $codes[@]"
    #     PRIGHT="$PRIGHT$(ansi codes[@]) "
    # fi
    CURRENT_RBG=$1
    [[ -n $3 ]] && PRIGHT="$PRIGHT$3"
}

######################################################################
## Emacs prompt --- for dir tracking
# stick the following in your .emacs if you use this:

# (setq dirtrack-list '(".*DIR *\\([^ ]*\\) DIR" 1 nil))
# (defun dirtrack-filter-out-pwd-prompt (string)
#   "dirtrack-mode doesn't remove the PWD match from the prompt.  This does."
#   ;; TODO: support dirtrack-mode's multiline regexp.
#   (if (and (stringp string) (string-match (first dirtrack-list) string))
#       (replace-match "" t t string 0)
#     string))
# (add-hook 'shell-mode-hook
#           #'(lambda ()
#               (dirtrack-mode 1)
#               (add-hook 'comint-preoutput-filter-functions
#                         'dirtrack-filter-out-pwd-prompt t t)))

prompt_emacsdir() {
    # no color or other setting... this will be deleted per above
    PR="DIR \w DIR$PR"
}

######################################################################
## Main prompt
change_colors
build_prompt() {
    [[ ! -z ${AG_EMACS_DIR+x} ]] && prompt_emacsdir
    prompt_status
    #[[ -z ${AG_NO_HIST+x} ]] && prompt_histdt
    [[ -z ${AG_NO_CONTEXT+x} ]] && 
    change_colors
	prompt_virtualenv
	prompt_host
    prompt_context
    prompt_dir
    prompt_git
    prompt_hg
    prompt_end
}

# from orig...
# export PS1='$(ansi_single $(text_effect reset)) $(build_prompt) '
# this doesn't work... new model: create a prompt via a PR variable and
# use that.

set_bash_prompt() {
    RETVAL=$?
    PR=""
    PRIGHT=""
    CURRENT_BG=NONE
    PR="$(ansi_single $(text_effect reset))"
    build_prompt

    # uncomment below to use right prompt
    #     PS1='\[$(tput sc; printf "%*s" $COLUMNS "$PRIGHT"; tput rc)\]'$PR
    PS1=$PR
}

PROMPT_COMMAND=set_bash_prompt
