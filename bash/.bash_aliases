alias h=history
alias emacs='emacs -nw'

export PATH=${PATH}:${HOME}/bin

# Detachable cmus (moc seems unmaintainted these days...)
alias cmus='screen -q -r -D cmus || screen -S cmus $(which cmus)'

# The idiot proof alias.
alias reboot='echo -n "Are you really sure this is what you want (y/n)? ";
              read _rep;
              if [ "$_rep" = "y" ]; then
                  /sbin/reboot
              fi'

# I like vim. e.g. for crontab
export EDITOR=/usr/bin/vim

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
alias vel='ls ${HOME}/.venv'
alias ved=deactivate

function vea() {
    _f="${HOME}/.venv/${1}/bin/activate"
    if [ -f "$_f" ]; then
        source ${HOME}/.venv/${1}/bin/activate
    else
        echo "$_f does not exist." >&2
    fi
}

function vec() {
    _f="${HOME}/.venv/${1}"
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
    time make $1 -j$NPROCS | tee "$(date +%Y%m%d%H%M).log"
}

if [ -f /usr/share/autojump/autojump.sh ]; then
	. /usr/share/autojump/autojump.sh
fi

# For customization that should not go to github !
if [ -f ~/.bash_custom ]; then
	. ~/.bash_custom
fi

