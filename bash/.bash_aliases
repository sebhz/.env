alias h=history

# Search for all files containing pattern
function fp() {
	if [ -z "$1" ]; then
		return
	fi
	find . -exec grep -iIl "$1" {} \; 2>/dev/null
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