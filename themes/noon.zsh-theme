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

# user part, color coded by privileges
local user="%(!.%{$fg[white]%}.%{$fg[white]%})%n@%{$reset_color%}"

# Compacted $PWD
local pwd="%{$fg[yellow]%}%c>%{$reset_color%}"

PROMPT='${time} ${user}%{$fg[cyan]%}$(branch)%{$reset_color%}${pwd}'
branch_thingy=""

# elaborate exitcode on the right when >0
return_code_enabled="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
return_code_disabled="%{$fg[magenta]%}%D{%a %b %d}%{$reset_color%}"
return_code=$return_code_disabled

RPROMPT='${return_code}$(battery_charge)'

function accept-line-or-clear-warning () {
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
    # The "br" command just returns the current branch in whatever typo of
    # repo I happen to be in.
    ~/bin/br 1>/dev/null 2>&1 && br | awk '{ print $1" " }'
}

function battery_charge  () {
    python ~/bin/scripts/batstate.py 2>/dev/null
}

zle -N accept-line-or-clear-warning
bindkey '^M' accept-line-or-clear-warning
