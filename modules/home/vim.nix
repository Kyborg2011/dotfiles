{ config, pkgs, ... }:

{
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-sensible
      vim-unimpaired
      vim-fugitive
      vim-surround
      vim-github-dashboard
      nerdtree
      nerdtree-git-plugin
      vim-nerdtree-syntax-highlight
      vim-devicons
      goyo-vim
      limelight-vim
      vim-gitgutter
      vim-airline
      vim-airline-themes
      ale
      vim-cmake
      vim-flog
      fzf-vim
      vim-startify
      gruvbox
      indentLine
      kotlin-vim
      vim-polyglot
      vim-ledger
      tagbar
      YouCompleteMe
      neomutt-vim
      vim-nix
      vim-bufferline
      #vim-gutentags
      LanguageClient-neovim
    ];
    settings = {
      background = "dark";
      number = true;
    };
    extraConfig = ''
      set nocompatible
      set autoindent
      set cursorline
      set foldmethod=indent
      set nofoldenable
      set modeline
      set expandtab
      set tabstop=4
      set shiftwidth=4
      set diffopt+=vertical

      " Exuberant Ctags:
      let g:gutentags_trace = 1

      syntax on
      colorscheme gruvbox

      " Airline settings:
      let g:airline_theme='molokai'
      let g:airline#extensions#tabline#enabled=1
      let g:airline_powerline_fonts=1

      " Gitgutter settings:
      let g:gitgutter_set_sign_backgrounds=0

      " Sets the working directory to the current file's directory:
      autocmd BufEnter * lcd %:p:h

      " Show signcolumn only in certain filetypes:
      autocmd BufRead,BufNewFile * set signcolumn=yes
      autocmd FileType tagbar,nerdtree set signcolumn=no

      " NERDTree keybindings:
      nnoremap <leader>n :NERDTreeFocus<CR>
      nnoremap <C-n> :NERDTree<CR>
      nnoremap <C-t> :NERDTreeToggle<CR>
      nnoremap <C-f> :NERDTreeFind<CR>

      " Start NERDTree when vim starts with no file arguments, but do not hide default vim startup window:
      autocmd StdinReadPre * let s:std_in=1
      autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | wincmd p | endif

      " Toggle next/pref buffer with <tab> key:
      nnoremap  <silent>   <tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bnext<CR>
      nnoremap  <silent> <s-tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bprevious<CR>

      if (empty($TMUX) && getenv('TERM_PROGRAM') != 'Apple_Terminal')
        if (has("nvim"))
          let $NVIM_TUI_ENABLE_TRUE_COLOR=1
        endif
      endif
    '';
  };

  home.packages = with pkgs; [
    fzf
    git
    nodejs
    python3
    cmake
    gcc
  ];
}
