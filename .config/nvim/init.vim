" === sensible defaults ===
syntax on
filetype plugin on
filetype indent on
set termguicolors
set autoindent smartindent

set updatetime=50
set guioptions=


set signcolumn=yes
set colorcolumn=81
highlight ColorColumn ctermbg=0 guibg=lightgrey
set cmdheight=2

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
set nowritebackup

" === keybinds ===
" leader
let mapleader=" "

" spell check
map <leader>o :setlocal spell! spelllang=en_us<CR>

" remove highlight
nnoremap <silent> <CR> :noh<CR><CR>
nnoremap <silent> <Esc> :noh<CR>

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
map <silent> <leader>H :w <bar> :e %:p:s,.h$,.X123X,:s,.c$,.h,:s,.X123X$,.c,<CR>

" compile vimwiki to pdf
map <silent> <leader>c :!vimwiki-compile %<CR>
map <silent> <leader>v :!vimwiki-open %<CR>

" toggle conceal level between 0 and 2
nnoremap <leader>z :let &cole=(&cole == 2) ? 0 : 2 <bar> echo 'conceallevel ' . &cole <CR>

" DP :))))
vnoremap <leader>p "_dP

" === auto ===
" on save remove trailing whitespace and newlines
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritePre * %s/\n\+\%$//e

" disable auto comments
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" center text
autocmd InsertEnter * norm zz

" compile suckless
autocmd BufWritePost config.h,config.def.h !rm config.h; make install

" == au ==
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 100})
augroup END

" == plugins ==
" download vim-plug if missing
if empty(glob("~/.local/share/nvim/site/autoload/plug.vim"))
  silent! execute '!sh -c curl -fLo
              \ "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs
              \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * silent! PlugInstall
endif

call plug#begin('~/.config/nvim/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'                         " fzf
Plug 'junegunn/goyo.vim'                        " center text
Plug 'itchyny/lightline.vim'                    " power line but light
Plug 'ap/vim-css-color'                         " color highlighting
Plug 'gruvbox-community/gruvbox'                " gruvbox
Plug 'unblevable/quick-scope'                   " faster horizontal find
Plug 'mbbill/undotree'                          " vim undo tree visualiser
Plug 'majutsushi/tagbar'                        " tagbar
Plug 'neovim/nvim-lspconfig'                    " lsp
Plug 'nvim-lua/completion-nvim'                 " autocomplete
" Plug 'nvim-lua/diagnostic-nvim'                 " diagnostics
Plug 'sheerun/vim-polyglot'                     " language packs
" Plug 'octol/vim-cpp-enhanced-highlight'         " cpp hl
Plug 'SirVer/ultisnips'                         " snippet engine
Plug 'honza/vim-snippets'                       " snippets
Plug 'miyakogi/seiya.vim'
call plug#end()

" === gruvbox ===
let g:gruvbox_italic=1
let g:gruvbox_contrast_dark='hard'
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
let g:gruvbox_invert_selection='0'
colorscheme gruvbox

" == diagnostic == (deprecated)
" lua << EOF
" local on_attach_vim = function(client)
"   require'completion'.on_attach(client)
"   require'diagnostic'.on_attach(client)
" end
" require'nvim_lsp'.tsserver.setup{on_attach=on_attach_vim}
" require'nvim_lsp'.ccls.setup{on_attach=on_attach_vim}
" require'nvim_lsp'.vimls.setup{on_attach=on_attach_vim}
" require'nvim_lsp'.jdtls.setup{on_attach=on_attach_vim}
" EOF
" let g:diagnostic_enable_underline = 0
" let g:diagnostic_enable_virtual_text = 1
" map <leader>k :PrevDiagnosticCycle<CR>
" map <leader>j :NextDiagnosticCycle<CR>
" map <leader>d :OpenDiagnostic<CR>

" == lsp ==
map <leader>k <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
map <leader>j <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
map <leader>d <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>
lua << EOF
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    underline = false,
    signs = true,
    update_in_insert = false,
  }
)
EOF


" == complete ==
lua require'nvim_lsp'.ccls.setup{on_attach=require'completion'.on_attach}
lua require'nvim_lsp'.vimls.setup{on_attach=require'completion'.on_attach}
set completeopt=menuone,noinsert,noselect
set shortmess+=c
let g:completion_timer_cycle = 50
let g:completion_trigger_on_delete = 1
let g:completion_matching_strategy_list = [ 'exact', 'substring', 'fuzzy' ]
let g:completion_enable_snippet = 'UltiSnips'

" == snippets ==
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" == vim go (polyglot) ==
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_format_strings = 1
let g:go_highlight_variable_declarations = 1
let g:go_auto_sameids = 1

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

" === goyo ===
map <leader>g :Goyo <cr>

" === lightline ===
" (with ale integration)
set laststatus=2
set noshowmode
let g:lightline={ 'colorscheme': 'gruvbox' }

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

" === cpp enhanced highlight ===
" let g:cpp_class_scope_highlight = 1
" let g:cpp_member_variable_highlight = 1
" let g:cpp_class_decl_highlight = 1
let g:cpp_posix_standard = 1
" let g:cpp_experimental_template_highlight = 1
" let g:cpp_concepts_highlight = 1
let g:cpp_no_function_highlight = 1

" === seiya ===
" let g:seiya_auto_enable=1
" let g:seiya_target_groups = has('nvim') ? ['guibg'] : ['ctermbg']
