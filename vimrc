let mapleader = ","

set backspace=2
set history=50
set lazyredraw
set incsearch           " do incremental searching
set laststatus=2        " Always display the status line
set nobackup
set nocompatible        " Use Vim settings, rather then Vi settings
set noswapfile
set nowritebackup
set nowrap
set ruler               " show the cursor position all the time
set showcmd             " display incomplete commands
set clipboard+=unnamed  " pasting
set ttimeoutlen=25
set undodir=$HOME/.vim/undo
set undolevels=1000
set undoreload=10000
set winwidth=80
set tabstop=2
set shiftwidth=2
set expandtab

syntax on

filetype plugin indent on

" Display extra whitespace
set list listchars=tab:»·,trail:·

" Use Ack instead of Grep when available
if executable("ag")
  set grepprg=ag\ --nogroup\ --nocolor
endif

" Open all grep commands into quicklist
autocmd QuickFixCmdPost *grep* cwindow

" Color scheme
set background=dark
hi NonText guibg=#060606
hi Folded  guibg=#0A0A0A guifg=#9090D0
hi LineNr  term=bold ctermfg=DarkGrey guifg=DarkGrey

" " Numbers
set relativenumber
set numberwidth=5

" Bubble single lines
nmap <C-Down> ]e
nmap <C-Up> [e

" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv

" Buffers
map <Leader>b :buffers<CR>:buffer<space>
map <Leader>gs :Gstatus<CR>
map <Leader>gac :Gcommit -m -a ""<LEFT>
map <Leader>gc :Gcommit -m ""<LEFT>
map <Leader>m :Rmodel
map <Leader>sm :RSmodel
map <Leader>su :RSunittest
map <Leader>sv :RSview
map <Leader>vc :RVcontroller<cr>
map <Leader>vf :RVfunctional<cr>
map <Leader>vi :tabe ~/.vimrc<CR>
map <Leader>vm :RVmodel<cr>
map <Leader>vu :RVunittest<CR>
map <Leader>vv :RVview<cr>

" File Operations
map <C-s> <esc>:w<CR>
imap <C-s> <esc>:w<CR>

" Snippets are activated by Shift+Tab
let g:snippetsEmu_key = "<S-Tab>"

" Tab completion options
set wildmode=list:longest,list:full
set complete=.,w,t

" Indent if we're at the beginning of a line. Else, do completion.
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<C-p>"
    endif
endfunction
inoremap <tab> <C-r>=InsertTabWrapper()<CR>
inoremap <s-tab> <C-n>

" Tags
let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"

" Remove trailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

" Cucumber navigation commands
autocmd User Rails Rnavcommand step features/step_definitions -glob=**/* -suffix=_steps.rb
autocmd User Rails Rnavcommand config config -glob=**/* -suffix=.rb -default=routes

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" vim-rspec mappings
nnoremap <Leader>t :call RunCurrentSpecFile()<CR>
nnoremap <Leader>s :call RunNearestSpec()<CR>
nnoremap <Leader>l :call RunLastSpec()<CR>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Improve syntax highlighting
au BufRead,BufNewFile Gemfile set filetype=ruby
au BufRead,BufNewFile *.md set filetype=markdown
au BufRead,BufNewFile *.md setlocal spell
au BufRead,BufNewFile *.md setlocal textwidth=80

" Open new split panes to right and bottom
set splitbelow
set splitright

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" configure syntastic syntax checking to check on open and save
let g:syntastic_check_on_open=1
let g:syntastic_ruby_exec='ruby-1.9.3-p194'

" configure nerdtree
map <F2> :NERDTreeToggle<CR>

" configure ctrlp
let g:ctrlp_show_hidden = 1
set wildignore+=*/tmp/*,*/log/*,.DS_Store

" Local config
if filereadable("~/.vimrc.local")
  source ~/.vimrc.local
endif
