alias h=history
alias emacs='emacs -nw'
alias vim=nvim

# Detachable cmus (moc seems unmaintainted these days...)
alias cmus='screen -q -r -D cmus || screen -S cmus $(which cmus)'

# The idiot proof alias.
alias reboot='echo -n "Are you really sure this is what you want (y/n)? ";
              read _rep;
              if [ "$_rep" = "y" ]; then
                  /sbin/reboot
              fi'

# Quick base conversions
alias hex='printf "%x\n"'
alias int='printf "%d\n"'

# I like vim. e.g. for crontab
export EDITOR=vim

# Tell ncurses to use Unicode box drawing when an UTF-8 locale is used
# To have ncurses programs like moc render nicely when using Putty for
# instance
export NCURSES_NO_UTF8_ACS=1

# To get correct colors in GNU screen
# Uncomment if not already set elsewhere (putty...)
# export TERM=xterm-256color

function screenk() {
    screen -X -S $1 quit
}

# Python virtualenv aliases and function
alias ved=deactivate
alias vel='ls ${HOME}/.venv'

function vea() {
    local _f="${HOME}/.venv/${1}/bin/activate"
    if [ -f "$_f" ]; then
        source "$_f"
    else
        echo "$_f does not exist." >&2
    fi
}
complete -W "$(vel)" vea

function vec() {
    local _f="${HOME}/.venv/${1}"
    if [ -f "$_f" ]; then
        echo "$_f already exists." >&2
    else
        python3 -m venv --system-site-packages "$_f"
    fi
}

# Search for all files containing pattern
# In case ag cannot be installed on the box
function fp() {
	if [ -z "$1" ]; then
		return
	fi
	find . -exec grep -iIl "$1" {} \; 2>/dev/null
}

# Make and get make log
function mka() {
    which nproc >/dev/null
    if [ $? -eq 0 ]; then
        NPROCS=$(nproc)
    else
        NPROCS=$(cat /proc/cpuinfo | grep processor | wc -l)
    fi
    time make $1 -j$NPROCS 2>&1 | tee "$(date +%Y%m%d%H%M).log"
}

if [ -f /usr/share/autojump/autojump.sh ]; then
	. /usr/share/autojump/autojump.sh
fi

# For customization that should not go to github !
if [ -f ~/.bash_custom ]; then
	. ~/.bash_custom
fi

