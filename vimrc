" Init {{{1

" madmax library
if !exists("g:vimconfig_dir")
    echoe "g:vimconfig_dir not set!"
    finish
endif
let &rtp .= "," . g:vimconfig_dir . "/vim"
let g:os_uname = substitute(system('uname'), '\n', '', '')
call madmax#Init()

" Leader key
let mapleader = ","

" }}}1

" Plugins {{{1

" Vundle {{{2

filetype off
set nocompatible
let &rtp .= "," . g:vimconfig_dir . "/vim/plugins/Vundle.vim"
call vundle#begin(g:vimconfig_dir . "/vim/plugins")

Plugin 'VundleVim/Vundle.vim'
Plugin 'SirVer/ultisnips'
Plugin 'taglist.vim'
Plugin 'xterm-color-table.vim'
Plugin 'L9'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'nvie/vim-flake8'
Plugin 'godlygeek/tabular'
Plugin 'tpope/vim-fugitive'
" Add Plugins here

call vundle#end()
filetype plugin indent on

" Ctrl-P {{{2

" Want to change mappings to split/tab open bufs
let g:ctrlp_extensions = ['buffertag', 'line', 'changes', 'mixed']
let g:ctrlp_switch_buffer = '0'
let g:ctrlp_working_path_mode = '0'
let g:ctrlp_use_caching = 1
let g:ctrlp_match_window = 'bottom,order:btt,min:10,max:10,results:25'
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_cache_dir = $HOME . '/.vim/.ctrlp'
let g:ctrlp_show_hidden = 1
let g:ctrlp_prompt_mappings = {
            \ 'PrtBS()':              ['<bs>', '<c-]>'],
            \ 'PrtDelete()':          ['<del>'],
            \ 'PrtDeleteWord()':      ['<c-w>'],
            \ 'PrtClear()':           ['<c-u>'],
            \ 'PrtSelectMove("j")':   ['<c-n>'],
            \ 'PrtSelectMove("k")':   ['<c-p>'],
            \ 'PrtSelectMove("u")':   ['<c-u>'],
            \ 'PrtSelectMove("d")':   ['<c-d>'],
            \ 'PrtHistory(-1)':       ['<c-r>'],
            \ 'PrtHistory(1)':        ['<c-f>'],
            \ 'AcceptSelection("e")': ['<cr>'],
            \ 'AcceptSelection("h")': ['<c-j>'],
            \ 'AcceptSelection("t")': ['<c-l>'],
            \ 'AcceptSelection("v")': ['<c-k>'],
            \ 'ToggleFocus()':        ['<s-tab>'],
            \ 'ToggleRegex()':        ['<c-t>'],
            \ 'ToggleByFname()':      ['<c-g>'],
            \ 'ToggleType(1)':        ['<c-m>'],
            \ 'ToggleType(-1)':       ['<c-b>'],
            \ 'PrtCurStart()':        ['<c-a>'],
            \ 'PrtCurEnd()':          ['<c-e>'],
            \ 'PrtClearCache()':      ['<F5>'],
            \ }
let g:ctrlp_map = '<leader>of'
let g:ctrlp_cmd = 'CtrlPMixed'
nnoremap <leader>or :CtrlPMRU<cr>
nnoremap <leader>ob :CtrlPBuffer<cr>
nnoremap <leader>oc :CtrlPChangeAll<cr>
nnoremap <leader>t :CtrlPBufTagAll<cr>
nnoremap <leader>/ :CtrlPLine<cr>

" }}}2

" YouCompleteMe {{{2

let g:ycm_global_ycm_extra_conf = "/home/max/.vim/ycm_extra_conf.py"
let g:ycm_enable_diagnostic_highlighting = 0

" }}}2

" UltiSnips {{{2

let g:UltiSnipsExpandTrigger = "<c-e>"

" }}}2

" Flake8 {{{2

let g:flake8_show_quickfix = 0
let g:flake8_show_in_gutter = 1
highlight link Flake8_Error      Error
highlight link Flake8_Warning    WarningMsg
highlight link Flake8_Complexity WarningMsg
highlight link Flake8_Naming     WarningMsg
highlight link Flake8_PyFlake    WarningMsg

" }}}2

" Taglist {{{2

noremap <silent> <leader>T :TlistToggle<cr>
let Tlist_Close_On_Select = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_Right_Window = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_WinWidth = 30
let Tlist_Enable_Fold_Column = 0
highlight link TagListFileName StatusLineNC
highlight link TagListTitle    Keyword
augroup TlistGrp
    autocmd!
    autocmd BufWinEnter * silent! TlistUpdate
    autocmd FileType taglist setlocal nonumber norelativenumber
augroup END

" Returns tag prototype for c/cpp files
function! TagName()
    if match(&filetype, '\v\c[ch](pp)?') != -1
        return Tlist_Get_Tagname_By_Line()
    endif
    return ''
endfunction

" }}}2

" UltiSnips {{{2

let g:UltiSnipsExpandTrigger = '<c-e>'
let g:UltiSnipsJumpForwardTrigger = '<c-e>'

" }}}2

" }}}1

" Settings {{{1

" Syntax highlighting {{{2

colorscheme madmax
syntax on

" }}}2

" Generic settings {{{2

set hlsearch incsearch                   " Search highlighting
set shiftwidth=4 softtabstop=4 expandtab " Default tab behaviour
set textwidth=80                         " Use 80 columns
set scrolloff=5                          " Keep some lines around the cursor
set backspace=2
set history=1000                         " Keep a longer history of things
set wildmenu wildmode=list:longest,full  " Wildmenu behavior
set completeopt=menuone,longest          " Use a popup for completion
set noswapfile                           " Don't use swapfiles
set nocompatible                         " No vi compatability
set hidden                               " Allow hidden buffers
set gdefault                             " Use g flags for :s by default
set number relativenumber                " Show line numbers
set showcmd                              " Show cmd in status bar
set wrap linebreak                       " Wrap lines, at reasonable points
set foldmethod=marker                    " No automatic folding
set foldopen=hor,insert,jump,mark        " When to open folds
set foldopen+=quickfix,search,tag,undo
set mouse=a                              " Allow using the mouse
set listchars=tab:t- list                " Explicity list tabs

" }}}2

" Vimdiff {{{2

" Do not start vimdiff in readonly mode
if &diff
    set noreadonly
endif

" }}}2

" Viminfo {{{2

" The following information is stored:
"   <100  Max. 100 lines per register
"   '100  Remember marks for the last 100 files
if has("viminfo")
    set viminfo=<100,'100,n~/.vim/.viminfo
endif

" }}}2

" Undofiles {{{2

let s:undodir = $HOME . "/.vim/undos"
if !isdirectory( s:undodir )
    call mkdir( s:undodir )
endif
let &undodir = s:undodir
set undofile

" }}}2

" }}}1

" Mappings and Commands {{{1

" Mappings {{{2

" Misc {{{3

" Convenience
inoremap jk <esc>
inoremap <c-c> <esc>
" ~/.vimrc editing
function! EditVimrc()
    execute "edit " . g:vimconfig_dir . "/vimrc"
endfunction
nnoremap <leader>ev :call EditVimrc()<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
" Snippet editing
let g:snippets_dir = g:vimconfig_dir . "/vim/snippets"
function! EditSnippets()
    execute "Explore " . g:snippets_dir
endfunction
nnoremap <leader>es :call EditSnippets()<cr>
" Prevent ex-mode, who uses that anyway?
nnoremap Q <nop>
" Clear hlsearch
noremap <leader>n :nohlsearch<cr>
" Close any help pages
nnoremap <leader>hc :helpclose<cr>
" Pasting in command mode
cnoremap <c-p> <c-r>"
" Message log
nnoremap <leader>m :messages<cr>
" Check highlighting
nnoremap <leader>hi :so $VIMRUNTIME/syntax/hitest.vim<cr>
" On macs, prevent non-breaking spaces
if g:os_uname ==# "Darwin"
    noremap! <a-space> <space>
endif
" Open keywordprg
noremap <leader>k K

" }}}3

" Editing {{{3

" Joing and splitting lines
nnoremap <leader>j J
nnoremap <leader>J xi<cr><esc>
" Moving lines down/up
nnoremap + ddp
nnoremap - ddkP

" }}}3

" Navigation {{{3

" 'Strong' [hjkl]
noremap H ^
noremap J G$
noremap K gg
noremap L $
" Go to previous file
nnoremap <leader>b :b#<cr>
" Make j/k navigate visually through wrapped lines
nnoremap j gj
nnoremap k gk
" Repeat latest [ftFT] in opposite direction
nnoremap ' ,
" Do not pollute jumplist with [{}]
nnoremap } :keepjumps normal! }<cr>
nnoremap { :keepjumps normal! {<cr>
" Quickfix navigation
nnoremap <leader><tab> :cn<cr>
nnoremap <leader><s-tab> :cp<cr>
" Jumplist navigation
nnoremap <s-tab> <c-o>
" Follow symbols with Enter
nnoremap <cr> <c-]>
nnoremap <leader><cr> :sp<cr><c-]>
" In quickfix and command window, unmap <cr>
augroup agUnmapCr
    autocmd!
    autocmd CmdwinEnter * noremap <buffer> <cr> <cr>
    autocmd BufReadPost quickfix noremap <buffer> <cr> <cr>
augroup END

" }}}3

" Marks using F1-F12 {{{3

nnoremap <leader><F1> mO
nnoremap <leader><F2> mP
nnoremap <leader><F3> mQ
nnoremap <leader><F4> mR
nnoremap <leader><F5> mS
nnoremap <leader><F6> mT
nnoremap <leader><F7> mU
nnoremap <leader><F8> mV
nnoremap <leader><F9> mW
nnoremap <leader><F10> mX
nnoremap <leader><F11> mY
nnoremap <leader><F12> mZ

nnoremap <F1> `O
nnoremap <F2> `P
nnoremap <F3> `Q
nnoremap <F4> `R
nnoremap <F5> `S
nnoremap <F6> `T
nnoremap <F7> `U
nnoremap <F8> `V
nnoremap <F9> `W
nnoremap <F10> `X
nnoremap <F11> `Y
nnoremap <F12> `Z

" }}}3

" Tab, splits and buffers {{{3

" More natural split directions
set splitright splitbelow
" This shouldn't close the window
nnoremap <c-w><c-c> <nop>
" Tab arrangement
nnoremap <silent> <c-w>Q :tabc<cr>
nnoremap <silent> <c-w>t :tabnew<cr>
" Save, close files
nnoremap <silent> <c-w>wq :wq<cr>
nnoremap <silent> <c-w>ww :w<cr>
nnoremap <silent> <c-w>w :w<cr>
" Split navigation
inoremap <silent> <c-j> <esc><c-w>j
inoremap <silent> <c-k> <esc><c-w>k
inoremap <silent> <c-h> <esc><c-w>h
inoremap <silent> <c-l> <esc><c-w>l
nnoremap <silent> <c-j> <c-w>j
nnoremap <silent> <c-k> <c-w>k
nnoremap <silent> <c-h> <c-w>h
nnoremap <silent> <c-l> <c-w>l
" Tab navigation
nnoremap <silent> <c-p> :tabp<cr>
nnoremap <silent> <c-n> :tabn<cr>
" Split arrangement
nnoremap <silent> <c-w>h <c-w>H
nnoremap <silent> <c-w>j <c-w>J
nnoremap <silent> <c-w>k <c-w>K
nnoremap <silent> <c-w>l <c-w>L

" }}}3

" Quickfix and location window toggle {{{3

noremap <silent> <leader>l :call madmax#togglelist#Toggle("Location List",
            \'l')<CR>
noremap <silent> <leader>q :call madmax#togglelist#Toggle("Quickfix List",
            \'c')<cr>:pclose<cr>

" }}}3

" }}}2

" Commands {{{2

" Ignore command typos
command! W w
command! Q q
command! Wq wq
command! WQ wq
" Change to directory of current file
command! Cd cd %:p:h

" }}}2

" }}}1

" Sessions {{{1

let &sessionoptions = "blank,sesdir,buffers,help,tabpages,folds"
augroup SessionGrp
    autocmd!
    autocmd VimEnter * nested call madmax#sessions#Restore()
    autocmd VimLeave * nested call madmax#sessions#Update()
augroup END

" }}}1

" Statusline and Tabline {{{1

" Statusline {{{2

function! MyStatusLine()
    let l:statusline  = '%n: %f%q %a%=%{TagName()} (%p%% c%c) %y %1*'
    let l:statusline .= '%{madmax#statusline#Modified()}'
    return l:statusline
endfunction
set laststatus=2
set statusline=%!MyStatusLine()

" }}}2

" Tabline {{{2

set showtabline=2
set tabline=%!madmax#tabline#MyTabLine()

" }}}2

" }}}1

" Yanking {{{1

" Yank Ring, to save frequent yanks to disk {{{2

nnoremap <leader>ry :set opfunc=madmax#yankring#Yank<cr>g@
vnoremap <leader>ry <esc>:call madmax#yankring#Yank('visual')<cr>
nnoremap <leader>rp :call madmax#yankring#Paste('p')<cr>
nnoremap <leader>rP :call madmax#yankring#Paste('P')<cr>
vnoremap <leader>rp d:call madmax#yankring#Paste('P')<cr>

" }}}2

" Yank to system clipboard {{{2

if has("clipboard")
    function! YankToClipboard(mode)
        " Mode is either 'char', 'block' or 'line'
        execute "normal! `[v`]\"+y"
    endfunction

    nnoremap <silent> <leader>y :set opfunc=YankToClipboard<cr>g@
    vnoremap <leader>y "+y
    nnoremap <leader>p "+p
    nnoremap <leader>P "+P
    vnoremap <leader>p d"+P
endif

" }}}2

" }}}1

" Restore cursor position per buffer {{{1

function! ResCur()
    if line("'\") <= line("$")
        normal! g`"
        return 1
    endif
endfunction

augroup ResCur
    autocmd!
    autocmd BufWinEnter * silent! call ResCur()
augroup END

" }}}1

" Maximize quickfix windows' width {{{1

function! MaxQuickfixWin()
    if &buftype ==# "quickfix"
        execute "normal! \<c-w>J"
    endif
endfunction
augroup MaxQuickfixWinGrp
    autocmd!
    autocmd BufWinEnter * call MaxQuickfixWin()
augroup END

" }}}1

" Un-/Commenting {{{1

noremap <silent> <leader>c :call madmax#comment#ToggleComment()<cr>

" }}}1

" Grep {{{1

let &grepprg = "grep -IHsn --color=auto $* /dev/null"
nnoremap <silent> <leader>G :call madmax#grep#Grep()<cr>
nnoremap <silent> <leader>g :set opfunc=madmax#grep#GrepOp<cr>g@
vnoremap <silent> <leader>g :<c-u>call madmax#grep#GrepOp(visualmode())<cr>

" }}}1

" Highlight bad style {{{1

augroup agHlBadStyle
    autocmd!
    autocmd FileType * call madmax#badstyle#HighlightBadStyle()
augroup END

" }}}1

" Prevent 'plaintex' ft {{{1

augroup agTexFt
    autocmd!
    autocmd FileType *.tex set ft=tex
augroup END

" }}}1

" Append mode line {{{1

function! AppendModeline()
    let l:modeline = printf("vim: set ts=%d sw=%d tw=%d %set :",
                \ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
    let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
    call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <Leader>M :call AppendModeline()<CR>

" }}}1
