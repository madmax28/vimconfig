"" Init {{{1

let g:os_uname = substitute(system('uname'), "\n", "", "")

"" Plugins {{{1

" Vundle
filetype off
set nocompatible
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/plugins')

Plugin 'gmarik/Vundle.vim'
Plugin 'snipMate'
Plugin 'taglist.vim'
Plugin 'xterm-color-table.vim'

" Add Plugins here
call vundle#end()
filetype plugin indent on

"" Taglist {{{1

noremap <silent> <leader>t :TlistToggle<cr>

let Tlist_Close_On_Select = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_Right_Window = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_WinWidth = 50

highlight link TagListFileName StatusLineNC
highlight link TagListTitle    Keyword

augroup TlistUpdate
    autocmd!
    autocmd BufWinEnter * :TlistUpdate
augroup END
"" Settings {{{1

syntax on
set hlsearch incsearch shiftwidth=4 softtabstop=4 expandtab smartindent ruler
    \ number scrolloff=5 backspace=2 nowrap history=1000 wildmenu
    \ completeopt=menuone,longest,preview wildmode=list:longest,full
    \ noswapfile nocompatible relativenumber hidden gdefault

" Folding
set foldmethod=marker foldclose=all
set foldopen=hor,insert,jump,mark,quickfix,search,tag,undo

" Use the mouse even without GUI
set mouse=a

" Leader key
let mapleader = ","

" Jump to existent windows when splitting new buffers
set switchbuf=useopen

" Viminfo
if has("viminfo")
    set viminfo=<100,%10,'10,n~/.viminfo
endif

"" Use undofiles {{{1
let s:undodir = $HOME . "/.vim/undos"
if !isdirectory( s:undodir )
    call mkdir( s:undodir )
endif
let &undodir = s:undodir
set undofile

"" Gui stuff {{{1
if has("gui")
    " Appearance
    if g:os_uname ==# "Darwin"
        set guifont=Monaco:h12 guioptions-=r guioptions-=R
    elseif g:os_uname ==# "Linux"
        set guifont=Monospace\ 10
    endif
    set guioptions-=l guioptions-=L guioptions-=b guioptions-=T guioptions-=m
    set guioptions-=r guioptions-=R
endif

"" Restore cursor position per buffer {{{1

function! ResCur()
    if line("'\"") <= line("$")
        normal! g`"
        return 1
    endif
endfunction

augroup ResCur
    autocmd!
    autocmd BufWinEnter * silent! call ResCur()
augroup END

"" Syntax and colors {{{1

" Use codeschool
colorscheme codeschool

highlight Error ctermbg=88 guibg=#880708
highlight RevSearch ctermfg=239 ctermbg=148 guifg=#e7ddd9 guibg=#74499b
highlight HighlightComment ctermbg=26 ctermfg=255 guibg=#4f76b6 guifg=#f0f0f0
highlight clear FoldColumn | highlight link FoldColumn Statusline
highlight clear CursorLineNr | highlight link CursorLineNr HighlightComment
highlight clear CursorLine | highlight link CursorLine HighlightComment
highlight clear CursorColumn | highlight link CursorColumn HighlightComment
highlight clear Todo | highlight Todo ctermbg=11 ctermfg=0 guibg=#ffff00
    \ guifg=#000000
highlight clear MatchParen | highlight link MatchParen Todo
highlight clear VertSplit | highlight link VertSplit LineNr

call matchadd('Todo', '\ctodo')

"" Status-/Tabline {{{1

" StatusLine
highlight StatusLine   cterm=NONE ctermbg=26 ctermfg=255 guibg=#4f76b6
            \ guifg=#005fdf
highlight User1        cterm=NONE ctermbg=26 ctermfg=9   guibg=#4f76b6
            \ guifg=#ff0000
highlight StatusLineNC cterm=NONE ctermbg=17 ctermfg=255 guibg=#00005f
            \ guifg=#f0f0f0

function! Modified()
    if &filetype ==# 'help'
        return ''
    endif

    if &modified
        return '[+]'
    endif

    return ''
endfunction

" Returns tag prototype for c/cpp files
function! Prototype()
    if match(&filetype, '\v\c[ch](pp)?') != -1
        return Tlist_Get_Tag_Prototype_By_Line()
    endif

    return ''
endfunction

function! MyStatusLine()
    let l:statusline = '%n: %f%q %a%=%{Prototype()} (%p%%) %y %1*%{Modified()}'
    return l:statusline
endfunction

set laststatus=2
set statusline=%!MyStatusLine()

" Tabline
highlight clear TabLineSel | highlight link TabLineSel HighlightComment
highlight clear TabLineFill | highlight link TabLineFill TabLine
highlight clear TabLine | highlight link TabLine StatusLineNC

function! MyTabLine()
    let s = ''

    for i in range(tabpagenr('$'))
        " Dont print labels if only one tab
        if tabpagenr('$') == 1
            break
        endif

        " Select the highlighting
        if i + 1 == tabpagenr()
            let s .= '%#TabLineSel#'
        else
            let s .= '%#TabLine#'
        endif
        " Set the tab page number (for mouse clicks)
        let s .= '%' . (i + 1) . 'T'
        " The label is made by MyTabLabel()
        let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
    endfor

    " After the last tab fill with TabLineFill and reset tab page nr
    let s .= '%#TabLineFill#%T'
    " Print currect working directory
    let s .= '%=cwd: ' . getcwd() . '%#TabLine#'

    return s
endfunction

function! MyTabLabel(n)
    let l:buflist  = tabpagebuflist(a:n)
    let l:winnr    = tabpagewinnr(a:n)
    " Extract filename
    let l:bufname  = bufname(l:buflist[l:winnr - 1])
    let l:filename = matchstr(l:bufname, '\v[^/]*$')
    if l:filename == ''
        return '[No Name]'
    else
        return l:filename
    endif
endfunction

set showtabline=2
set tabline=%!MyTabLine()


" Things to do when a buffer is entered
function! OnBufEnter()
    if &filetype !=# "help" || &filetype !=# "taglist"
        call HighlightCursor()
    endif
endfunction

" Make cursor easier visible after switching the buffer and jumping to the next
" search result
nnoremap n n:call HighlightCursor("Match")<cr>
nnoremap N N:call HighlightCursor("Match")<cr>
vnoremap n <esc>n:call HighlightCursor("Match")<cr>
vnoremap N <esc>N:call HighlightCursor("Match")<cr>

"" Un-/Commenting {{{1

" Things to do when a filetype is detected
function! OnFileType()
    " Decide which character starts a comment
    if &filetype ==# "vim"
        let b:cString = '"'
    elseif &filetype ==# "c" || &filetype ==# "cpp"
        let b:cString = '\/\/'
    elseif &filetype ==# "bash" || &filetype ==# "sh" || &filetype ==# "python" || &filetype ==# "conf"
        let b:cString = '#'
    elseif &filetype ==# "xml"
        let b:cString = '<!--'
        let b:cEndString = '-->'
    endif
endfunction

" (Un)commenting lines
function! ToggleComment()
    if !exists("b:cString")
        return
    else
        let v:errmsg = ""
        " Comment
        silent! execute ':s/\v^(\s*)((\V' . b:cString . '\v)|\s)@!/' . b:cString .
            \ ' \1\2'
        if v:errmsg == ""
            " Add closing comment string at end of line if needed
            if exists("b:cEndString")
                silent! execute ':s/$/ ' . b:cEndString . '/'
            endif
            return
        endif

        " Uncomment
        silent! execute ':s/\v^(\s*)(\V' . b:cString . '\v)\s(\s*)/\1\3/'
        if exists("b:cEndString")
            silent! execute ':s/ ' . b:cEndString . '$//'
        endif
    endif
endfunction

noremap <silent> <leader>c :call ToggleComment()<cr>

"" Highlight bad style {{{1

highlight link BadStyle Error

function! HighlightBadStyle()
    " Dont highlight in help files
    if &filetype ==# "help"
        return
    endif

    " Character on 80th column
    call matchadd('BadStyle', '\%80v.')
    " Trailing whitespaces
    call matchadd('BadStyle', '\s\+\n')
    " More than one newline in a row
"     call matchadd('BadStyle', '^\n\n\+')
    " Non-breaking spaces, useful on Macs, where i tend to hit Alt+Space
    call matchadd('BadStyle', ' ')
endfunction

augroup HighlightBadStyle
    autocmd!
    autocmd FileType * call HighlightBadStyle()
augroup END

"" TODO Execute programs/scripts from within vim {{{1

"" Search and Replace {{{1

" TODO make it accept a range
function! SearchAndReplace(mode, ...)
    " In normal mode
    if a:mode ==# "normal"
        if a:0 > 0
            if a:1 ==# "iw"
                " S&R word under cursor
                silent! execute "normal! viwy"
            elseif a:1 ==# "iW"
                " S&R WORD under cursor
                silent! execute "normal! viWy"
            endif
        else
            " No argument given. Ask for what to replace
            let l:word = input("What to replace? ")
        endif
    endif

    " Escape backslashes
    let l:word = escape(@", '\')

    " If the string is a whole keyword, only replace if
    " not preceded/followed by keyword character
    echo l:word
    if match(l:word, '^\k\+$') > -1
        let l:pattern = '\<' . l:word . '\>'
        let l:isKeyword = 1
    else
        let l:isKeyword = 0
        let l:pattern = l:word
    endif

    " Highlight all words
    let l:match = matchadd('Error', l:word)
    redraw!
    call matchdelete(l:match)

    " Get string with which to substitute
    let l:replaceString = input("Replace \"" . l:word . "\" with: ")

    " Perform substitution
    execute '%s/\V' . l:pattern . "/" . l:replaceString . "/g"

    " Set last search to inserted string
    if l:isKeyword
        let @/ = '\<' . l:replaceString . '\>'
    else
        let @/ = l:replaceString
    endif
    set hlsearch
endfunction

" Search and Replace stuff TODO: Think about when to use \< and \>
vnoremap <leader>r y:call SearchAndReplace("visual")<cr>
nnoremap <leader>rr v:call SearchAndReplace("normal")<cr>
nnoremap <leader>riw :call SearchAndReplace("normal", "iw")<cr>
nnoremap <leader>riW :call SearchAndReplace("normal", "iW")<cr>


"" Yank and paste to clipboard {{{1

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

"" Mappings {{{1

" Follow symbols with Enter
nnoremap <cr> <c-]>
" Not in quickfix windows though
augroup QuickfixCr
    autocmd!
    autocmd BufReadPost quickfix noremap <buffer> <cr> <cr>
augroup END

" Moving lines or blocks
nnoremap + ddp
nnoremap - ddkP

" Quickfix
nnoremap <leader>q :copen<cr>

" Apple specific stuff
if g:os_uname ==# "Darwin"
    noremap! <a-space> <space>
endif

" Joing lines
nnoremap <leader>j J
nnoremap <leader>J kJ

" 'Strong' hjkl
noremap K gg
noremap H ^
noremap J G$
noremap L $

" Clear hlsearch
noremap <leader>n :nohlsearch<cr>

" Message log
nnoremap <leader>m :messages<cr>

" Check highlighting
nnoremap <leader>hi :so $VIMRUNTIME/syntax/hitest.vim<cr>
inoremap jk <esc>

" Pasting in command mode
cnoremap <c-p> <c-r>"

" Ignore command typos
command! W w
command! Q q
command! Wq wq
command! WQ wq

" Building
nnoremap <silent> <leader>b :wa<cr>:make<cr>:cw<cr>

" ~/.vimrc editing
nnoremap <leader>ev :e $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Jumplist navigation
nnoremap <s-tab> <c-o>

"" Tabs and splits {{{1

" More natural split directions
set splitright splitbelow

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

"" Maximize quickfix windows' width {{{1

function! MaxQuickfixWin()
    if &buftype ==# "quickfix"
        execute "normal! \<c-w>J"
    endif
endfunction
augroup MaxQuickfixWinGrp
    autocmd!
    autocmd BufWinEnter * call MaxQuickfixWin()
augroup END

"" Cscope stuff {{{1

let s:myscope_dir = getcwd() . '/.myscope'
let s:cscope_db   = s:myscope_dir . '/cscope.out'

" Add any cscope databases present in current working directory
function! AddCscopeDb()
    if filereadable( s:cscope_db )
        echom "Added cscope db"
        execute "silent! cs add " . s:cscope_db
        " Avoid duplicate databases
        silent! cscope reset
    else
        echoe "Couldn't find cscope db"
    endif
    redraw!
endfunction

" Add any cscope databases present in current working directory
" If none are present, call AirTies' newscript.sh to generate one and add it
function! AddCreateCscopeDb()
    if filereadable( s:cscope_db )
        echom "Rebuilding cscope db"
        call delete( s:cscope_db )
    endif

    execute "silent! !~/.vim/bin/myscope.sh " . getcwd()

    if filereadable( s:cscope_db )
        call AddCscopeDb()
    else
        echoe "Couldn't create Cscope db"
    endif
endfunction

if has("cscope")
    " Use a quickfix window
    if has("quickfix")
        set cscopequickfix=s-,c-,d-,i-,t-,e-
    endif

    " Use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag
    " Check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set csto=0
    " Show msg when any other cscope db added
    set cscopeverbose

    " Automatically add Cscope db
    augroup AddCreateCscopeDb
        autocmd!
        autocmd BufCreate * silent! call AddCscopeDb()
    augroup END

    " Mappings
    nnoremap <leader>fa :call AddCreateCscopeDb()<CR>

    nnoremap <leader>fs :cs find s <C-R>=expand("<cword>")<cr><cr><c-o>:cw<cr>
    nnoremap <leader>fg :cs find g <C-R>=expand("<cword>")<cr><cr>
    nnoremap <leader>fc :cs find c <C-R>=expand("<cword>")<cr><cr><c-o>:cw<cr>
    nnoremap <leader>ft :cs find t <C-R>=expand("<cword>")<cr><cr><c-o>:cw<cr>
    nnoremap <leader>fe :cs find e <C-R>=expand("<cword>")<cr><cr><c-o>:cw<cr>
    nnoremap <leader>ff :cs find f <C-R>=expand("<cfile>")<cr><cr>
    nnoremap <leader>fi :cs find i ^<C-R>=expand("<cfile>")<cr>$<cr>
    nnoremap <leader>fd :cs find d <C-R>=expand("<cword>")<cr><cr>

    nnoremap <leader>Fs :vert scs find s <C-R>=expand("<cword>")<cr><cr>
    nnoremap <leader>Fg :vert scs find g <C-R>=expand("<cword>")<cr><cr>
    nnoremap <leader>Fc :vert scs find c <C-R>=expand("<cword>")<cr><cr>
    nnoremap <leader>Ft :vert scs find t <C-R>=expand("<cword>")<cr><cr>
    nnoremap <leader>Fe :vert scs find e <C-R>=expand("<cword>")<cr><cr>
    nnoremap <leader>Ff :vert scs find f <C-R>=expand("<cfile>")<cr><cr>
    nnoremap <leader>Fi :vert scs find i ^<C-R>=expand("<cfile>")<cr>$<cr>
    nnoremap <leader>Fd :vert scs find d <C-R>=expand("<cword>")<cr><cr>
endif

