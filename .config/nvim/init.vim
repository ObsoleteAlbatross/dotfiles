" === sensible defaults ===
syntax on
filetype plugin on
filetype indent on
set termguicolors
set autoindent smartindent

set colorcolumn=81
highlight ColorColumn ctermbg=0 guibg=lightgrey

set mouse=a
set scrolloff=8
set ignorecase
set smartcase
set encoding=utf-8
set number relativenumber
set nocompatible
set t_Co=256
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

set clipboard+=unnamedplus
set history=500
set hlsearch
set incsearch
set lazyredraw
set magic
set mat=2
set nobackup
set noerrorbells
set noswapfile
set novisualbell
set nowb
set showcmd
set showmatch
set ai
set si
set smarttab
set t_vb=
set tm=500
set wildmenu
set wildmode=longest,list,full
set nowrap
set nowritebackup

" === binds ===
" leader
let mapleader=" "

" spell check
map <leader>o :setlocal spell! spelllang=en_us<CR>

" remove highlight
nnoremap <silent> <CR> :noh<CR><CR>

" regex sub
nnoremap S :%s//g<Left><Left>

" splits
set splitbelow splitright
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <silent> <C-Right> :vertical resize +1<CR>
nnoremap <silent> <C-Left> :vertical resize -1<CR>
nnoremap <silent> <C-Up> :resize +1<CR>
nnoremap <silent> <C-Down> :resize -1<CR>

" indenting visual block
vmap < <gv
vmap > >gv

" toggle tagbar
nmap <silent> <leader>t :TagbarToggle<CR>

" open corresponding C++ header/source file in split
map <silent> <leader>h :w <bar> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>

" compile vimwiki to pdf
map <silent> <leader>c :!vimwiki-compile %<CR>
map <silent> <leader>v :!vimwiki-open %<CR>

" toggle conceal level between 0 and 2
nnoremap <leader>z :let &cole=(&cole == 2) ? 0 : 2 <bar> echo 'conceallevel ' . &cole <CR>

" === auto ===
" on save remove trailing whitespace and newlines
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritePre * %s/\n\+\%$//e

" disable auto comments
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" center text
autocmd InsertEnter * norm zz

" compile suckless
autocmd BufWritePost config.h,config.def.h !rm config.h; make clean install

" == ale ==
let g:ale_disable_lsp=1 " needed before ale is loaded and to work with coc
let g:ale_lint_on_enter=1
let g:ale_lint_on_text_changed='never'
let g:ale_lint_on_save=1
let g:ale_sign_column_always=1
let g:ale_set_highlights=0
let g:ale_echo_msg_error_str='error'
let g:ale_echo_msg_warning_str='warning'
let g:ale_echo_msg_format='[%linter%] %s [%severity%]'
nmap <silent> <C-e> <Plug>(ale_next_wrap)

" == plugged ==
" download vim-plug if missing
if empty(glob("~/.local/share/nvim/site/autoload/plug.vim"))
  silent! execute '!sh -c curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs
              \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * silent! PlugInstall
endif

call plug#begin('~/.config/nvim/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'                         " fzf
Plug 'junegunn/goyo.vim'                        " center text
Plug 'neoclide/coc.nvim', {'branch': 'release'} " code completion
Plug 'kevinoid/vim-jsonc'                       " jsonc for coc-settings
Plug 'itchyny/lightline.vim'                    " power line but light
Plug 'ap/vim-css-color'                         " color highlighting
Plug 'gruvbox-community/gruvbox'
Plug 'vimwiki/vimwiki'                          " vimwiki
Plug 'unblevable/quick-scope'                   " faster horizontal find
Plug 'sheerun/vim-polyglot'                     " language packs
Plug 'airblade/vim-rooter'                      " change working dir to root
Plug 'mbbill/undotree'                          " vim undo tree visualiser
Plug 'dense-analysis/ale'                       " async lint engine
Plug 'maximbaz/lightline-ale'                   " ale warnings in lightline
Plug 'majutsushi/tagbar'                        " tagbar
Plug 'jackguo380/vim-lsp-cxx-highlight'         " semantic c hl
call plug#end()

" === vimwiki ===
let g:vimwiki_table_mappings=0
let g:vimwiki_conceallevel=2
let g:vimwiki_list=[{'path': '$HOME/notes/vimwiki'}]
function! VimwikiLinkHandler(link)
  let link=a:link
  if link =~# '^vfile:'
    let link=link[1:]
  else
    return 0
  endif
  let link_infos=vimwiki#base#resolve_link(link)
  if link_infos.filename == ''
    echomsg 'Unresolved link'
    return 0
  else
    exe 'vs ' . fnameescape(link_infos.filename)
    return 1
  endif
endfunction

" == netrw ==
let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_browse_split=4
let g:netrw_winsize=20

noremap <silent> <leader>e :call NetrwToggle()<CR>

augroup netrw_mappings
  autocmd!
  autocmd filetype netrw call NetrwBinds()
augroup END

function! NetrwBinds()
  noremap <buffer> V :call OpenRight()<CR>
  noremap <buffer> H :call OpenDown()<CR>
endfunction

function! OpenRight()
  :normal v
  let g:path=expand('%:p')
  execute 'q!'
  execute 'belowright vnew' g:path
  :normal <C-w>l
endfunction

function! OpenDown()
  :normal v
  let g:path=expand('%:p')
  execute 'q!'
  execute 'belowright new' g:path
  :normal <C-w>l
endfunction

function! NetrwToggle()
    if g:NetrwIsOpen
        let i=bufnr("$")
        while (i >= 1)
            if (getbufvar(i, "&filetype") == "netrw")
                silent exe "bwipeout " . i
            endif
            let i-=1
        endwhile
        let g:NetrwIsOpen=0
    else
        let g:NetrwIsOpen=1
        silent Lexplore
    endif
endfunction

function! NetrwBufferOpen()
  if exists('b:noNetrw')
      return
  endif
  call NetrwToggle()
endfun

autocmd WinEnter * if winnr('$') == 1
      \ && getbufvar(winbufnr(winnr()), "&filetype") == "netrw"
      \ || &buftype == 'quickfix' |q|endif

let g:NetrwIsOpen=0

" === gruvbox ===
let g:gruvbox_italic=1
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox

" === goyo ===
map <leader>g :Goyo <cr>

" === lightline ===
" (with ale integration)
set laststatus=2
set noshowmode
let g:lightline={ 'colorscheme': 'gruvbox' }
let g:lightline.component_expand={
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_infos': 'lightline#ale#infos',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ }
let g:lightline.component_type={
      \     'linter_checking': 'right',
      \     'linter_infos': 'right',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'right',
      \ }
let g:lightline.active={
            \ 'left': [ [ 'mode', 'paste' ],
            \           [ 'readonly', 'filename', 'modified' ] ],
            \ 'right': [ [ 'linter_checking', 'linter_errors',
            \              'linter_warnings', 'linter_infos', 'linter_ok' ],
            \            [ 'lineinfo', 'percent' ],
            \            [ 'fileformat', 'fileencoding', 'filetype' ] ] }


" === quick scope ===
" trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys=['f', 'F', 't', 'T']

" === undo tree ===
if has("persistent_undo")
    set undodir=$HOME/.cache/undodir
    set undofile
endif
let g:undotree_HighlightChangedText=0
nnoremap <leader>u :UndotreeToggle<CR>

" === fzf ===
" with ripgrep
let g:rg_derive_root='true'
map <leader>f :Files<CR>
command! -bang -nargs=? -complete=dir Files
      \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
map <C-f> :RG<CR>
function! RipgrepFzf(query, fullscreen)
  let command_fmt='rg --column --line-number --hidden --no-heading
              \         --color=always --ignore-case -- %s || true'
  let initial_command=printf(command_fmt, shellescape(a:query))
  let reload_command=printf(command_fmt, '{q}')
  let spec={'options': ['--phony', '--query', a:query,
              \           '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
autocmd! FileType fzf set laststatus=0 noshowmode noruler
            \ | autocmd BufLeave <buffer> set laststatus=2 showmode ruler

" === coc ===
" extensions list
let g:coc_global_extensions =
            \ [ 'coc-clangd', 'coc-cmake', 'coc-css', 'coc-cssmodules', 'coc-dictionary',
            \   'coc-json', 'coc-format-json', 'coc-marketplace', 'coc-pairs', 'coc-go',
            \   'coc-html', 'coc-java', 'coc-lua', 'coc-phpls', 'coc-prettier', 'coc-python',
            \   'coc-rls', 'coc-sh', 'coc-sh', 'coc-syntax', 'coc-vimtex', 'coc-tag',
            \   'coc-vimlsp', 'coc-word', 'coc-zi']
set cmdheight=2
set updatetime=50
if has("patch-8.1.1564")
    set signcolumn=number
else
    set signcolumn=yes
endif

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col=col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable()?
      \ "\<C-r>=coc#rpc#request('doKeymap',['snippets-expand-jump', ''])\<CR>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

let g:coc_snippet_next='<tab>'

" use <c-space>for trigger completion
inoremap <silent><expr> <c-space> coc#refresh()
" Use <Tab> and <S-Tab> to nav completion list
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" use <cr> to confirm completion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" <cr> confirm completion when none is selected
" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() :
"             \ "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" close preview window when completion done
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" coc jump to def
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" coc format
" <leader>f moved to netrw toggle
" map <leader>f :Format<CR>

" coc show documentation
nnoremap <silent> <leader>d :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" coc symbol rename
nmap <leader>rn <Plug>(coc-rename)

imap <C-l> <Plug>(coc-snippets-expand)
vmap <C-j> <Plug>(coc-snippets-select)
let g:coc_snippet_next='<c-j>'
let g:coc_snippet_prev='<c-k>'
imap <C-j> <Plug>(coc-snippets-expand-jump)

command! -nargs=0 Format :call CocAction('format')

" === misc ===
" clear color of sign gutter
highlight clear SignColumn
