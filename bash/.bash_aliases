alias h=history
alias emacs='emacs -nw'

# I like vim. e.g. for crontab
export EDITOR=/usr/bin/vim

# Tell ncurses to use Unicode box drawing when an UTF-8 locale is used
# To have ncurses programs like moc render nicely when using Putty for
# instance
export NCURSES_NO_UTF8_ACS=1

# To get correct colors in GNU screen
# Uncomment if not already sent, if using puTTY for example
# export TERM=xterm-256color

# Search for all files containing pattern
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

# Some programs seem to be stored in .local/bin (?)
if [ -d ~/.local/bin ]; then
	export PATH=~/.local/bin:${PATH}
fi

# For customization that should not go to github !
if [ -f ~/.bash_custom ]; then
	. ~/.bash_custom
fi

