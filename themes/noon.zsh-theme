# "noon" by Noon Silk - http://github.com/silky
#
# Screenshot: http://i.imgur.com/EoYZz.png
#
# This theme is essentially "dieter", with a bit of stuff removed (git related
# prompt stuff). I also added the time into the prompt, and the date on the 
# right prompt. The comments below are his.
#
# --

# the idea of this theme is to contain a lot of info in a small string, by
# compressing some parts and colorcoding, which bring useful visual cues,
# while limiting the amount of colors and such to keep it easy on the eyes.
# When a command exited >0, the timestamp will be in red and the exit code
# will be on the right edge.
# The exit code visual cues will only display once.
# (i.e. they will be reset, even if you hit enter a few times on empty command prompts)

# local time, color coded by last return code
time_enabled="%(?.%{$fg[magenta]%}.%{$fg[red]%}⚡ )%D{%I:%M %p}%{$reset_color%}"
time_disabled="%{$fg[magenta]%}%D{%I:%M %p}%{$reset_color%}"
time=$time_enabled
# This isn't re-evaluated when env vars change.
# taskfilter=`echo $TW_FILTER`

# if [ "${taskfilter}" = "" ]; then
#     taskmessage=''
# else
#     taskmessage=" %{$fg[blue]%}[${taskfilter}]%{$reset_color%}"
# fi

# If we can do sudo things, then colour things red.
if [ "$(sudo -n echo 1 2>/dev/null)" = "1" ]; then
    user="%(!.%{$fg[white]%}.%{$fg[red]%})%n ∈ %{$reset_color%}"
else
    user="%(!.%{$fg[white]%}.%{$fg[white]%})%n ∈ %{$reset_color%}"
fi

# Compacted $PWD
local pwd="%{$fg[yellow]%}%c%{$reset_color%}"

PROMPT='${time} ${user}$(cabal_sandbox_info)${pwd}%{$fg[cyan]%}$(branch)%{$reset_color%}%{$fg[yellow]%}>%{$reset_color%}'

# elaborate exitcode on the right when >0
return_code_enabled="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
return_code_disabled="%{$fg[magenta]%}%D{%a %b %d}%{$reset_color%}"
return_code=$return_code_disabled


function cabal_sandbox_info() {
    cabal_files=(*.cabal(N))
    if [ -f cabal.sandbox.config ]; then
        echo "%{$fg[blue]%} ₻ %{$reset_color%}"
    fi
}


RPROMPT='${return_code}$(battery_charge)'

function accept-line-or-clear-warning () {
    if [ "$(sudo -n echo 1 2>/dev/null)" = "1" ]; then
        user="%(!.%{$fg[white]%}.%{$fg[red]%})%n ∈ %{$reset_color%}"
    else
        user="%(!.%{$fg[white]%}.%{$fg[white]%})%n ∈ %{$reset_color%}"
    fi

	if [[ -z $BUFFER ]]; then
		time=$time_disabled
		return_code=$return_code_disabled
	else
		time=$time_enabled
		return_code=$return_code_enabled
	fi
	zle accept-line
}

function branch () {
    # Only run "foo" if it is possible to run "foo". Lame but works.
    # The "br" command just returns the current branch in whatever type of
    # repo I happen to be in.
    ~/bin/br 1>/dev/null 2>&1 && br | awk '{ print "@"$0 }'
}

function battery_charge  () {
    python ~/bin/scripts/batstate.py 2>/dev/null
}

zle -N accept-line-or-clear-warning
bindkey '^M' accept-line-or-clear-warning
