set nocompatible    " use vim defaults
set ls=2            " always show status line
set tabstop=4       " numbers of spaces of tab character
set shiftwidth=4    " numbers of spaces to (auto)indent
set expandtab       " replace tabs by spaces
set scrolloff=3     " keep 3 lines when scrolling
set showcmd         " display incomplete commands
set hlsearch        " highlight searches
set incsearch       " do incremental searching
set ruler           " show the cursor position all the time
set visualbell t_vb=    " turn off error beep/flash
set novisualbell    " turn off visual bell
set nobackup        " do not keep a backup file
set number          " show line numbers
set ignorecase      " ignore case when searching
set title           " show title in console title bar
set ttyfast         " smoother changes
set modeline        " last lines in document sets vim mode
set modelines=3     " number lines checked for modelines
set shortmess=atI   " Abbreviate messages
set nostartofline   " don't jump to first character when paging
set whichwrap=b,s,h,l " move freely between files
" 
set noautoindent
set nosmartindent
set nocindent

let c_space_errors = 1

" Somehow this seems to be needed when working with Eterm
if &term == "Eterm"
	set t_kb=
	fixdel
	set t_kD=[3~
endif

" Some syntax coloring
set t_Co=256
syntax on           " syntax highlighing
set background=dark " adapt colors for background
colors peaksea

" No tab expansion for makefiles
autocmd FileType make set noexpandtab

" Extra whitespaces highlighting
" Highlight trailing whitespaces and spaces followed by tabs
highlight ExtraWhitespace ctermbg=red guibg=red
augroup extra_ws
	autocmd!
	autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/
augroup END

" Commenting blocks of code.
augroup block_comment
	autocmd!
	autocmd FileType c,cpp,java,scala let b:comment_leader = '// '
	autocmd FileType sh,ruby,python   let b:comment_leader = '# '
	autocmd FileType conf,fstab       let b:comment_leader = '# '
	autocmd FileType tex              let b:comment_leader = '% '
	autocmd FileType mail             let b:comment_leader = '> '
	autocmd FileType vim              let b:comment_leader = '" '
augroup END
noremap <silent> ,cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> ,cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

" Breaking out of the habit of searching for the arrows
noremap  <Up> <Nop>
noremap  <Down> <Nop>
noremap  <Left> <Nop>
noremap  <Right> <Nop>

