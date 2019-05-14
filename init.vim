" PLUGIN HELPER FUNCTIONS
function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    !./install.py --clang-completer --rust-completer
  endif
endfunction

call plug#begin('~/.local/share/nvim/plugged')
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    Plug 'tpope/vim-surround'
    Plug 'scrooloose/nerdtree'
    Plug 'tpope/vim-eunuch'
    Plug 'https://github.com/Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
    Plug 'majutsushi/tagbar'
    Plug 'godlygeek/tabular'
    Plug 'jiangmiao/auto-pairs'

    " THEME PLUGINS
    Plug 'axvr/photon.vim'
    Plug 'DankNeon/vim'
    Plug 'joshdick/onedark.vim'
    Plug 'rafi/awesome-vim-colorschemes'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

    " SYNTAX HIGHLIGHTING
    Plug 'Shirk/vim-gas'
    Plug 'w0rp/ale'
    Plug 'rust-lang/rust.vim'
    Plug 'theos/logos', { 'rtp': '/extras/vim' }
    Plug 'ARM9/arm-syntax-vim'
call plug#end()

" THEME SETTINGS
colorscheme gruvbox
set background=dark

" GENERAL SETTINGS
syntax on
set number relativenumber
set nu rnu
let g:asmsyntax         = 'nasm'

" TAB SETTINGS
set expandtab
set shiftwidth=4
set autoindent
set smartindent

" KEY MAP SETTINGS
let mapleader = ','
inoremap jj <Esc>
map ; :Files<CR>
map <C-o> :NERDTreeToggle<CR>
nmap <F8> :TagbarToggle<CR>
map <F5> :w<CR> :!clear; make NAME="%<"<cr> :!./%<<CR>
nmap <Tab> gt
vmap <Tab> gt
nmap <C-Tab> gT
vmap <C-Tab> gT

" SYNTASTIC : NASM
if has("macunix")
    let g:python2_host_prog = '/usr/local/bin/python'
    let g:python3_host_prog = '/usr/local/bin/python3'
    let g:syntastic_nasm_nasm_args = '-f macho64 -F'
    let g:ale_nasm_nasm_options = '-f macho64 -F'
elseif has("unix")
    let g:python2_host_prog = '/usr/bin/python'
    let g:python3_host_prog = '/usr/bin/python3'
    let g_syntastic_nasm_nasm_args = '-f elf64 -F'
    let g:ale_nasm_nasm_options = '-f elf64 -F'
endif

" YCM SETTINGS
let g:ycm_global_ycm_extra_conf = '~/.local/share/nvim/plugged/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
let g:ycm_autoclose_preview_window_after_completion = 0

" Command to get our rust path thanks to the help of rustc.
let g:ycm_rust_src_path = system('rustc --print sysroot') + '/lib/rustlib/src/rust/src'
    
nnoremap <leader>d :YcmCompleter GoToDefinition<cr>
nnoremap <leader>D :YcmCompleter GoToDeclaration<cr>

" NERDTREE SCRIPTS
nmap <C-o> :NERDTreeToggle<CR>
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Tabular
if exists(":Tab")
    nmap <Leader>a= :Tab /=<CR>
    vmap <Leader>a= :Tab /=<CR>
    nmap <Leader>a: :Tab /:<CR>
    vmap <Leader>a: :Tab /:<CR>
endif

au BufNewFile,BufRead *.xm,*.xmm,*.l.mm setf logos
au BufNewFile,BufRead *.xm,*.xmm,*.l.mm set syntax=logos
au BufNewFile,BufRead *.aasm set filetype=arm " arm = armv6/7
