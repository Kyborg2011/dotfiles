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
      #vim-virtualenv
      #vim-bufmru
      vim-cmake
      #LanguageClient-neovim
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
    ];
    settings = {
      background = "dark";
      number = true;
    };
    extraConfig = ''
      syntax on
      colorscheme gruvbox

      " Sets the working directory to the current file's directory:
      autocmd BufEnter * lcd %:p:h

      nnoremap <leader>n :NERDTreeFocus<CR>
      nnoremap <C-n> :NERDTree<CR>
      nnoremap <C-t> :NERDTreeToggle<CR>
      nnoremap <C-f> :NERDTreeFind<CR>

      " Start NERDTree when Vim is started without file arguments.
      autocmd StdinReadPre * let s:std_in=1
      autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

      if (empty($TMUX) && getenv('TERM_PROGRAM') != 'Apple_Terminal')
        if (has("nvim"))
          let $NVIM_TUI_ENABLE_TRUE_COLOR=1
        endif
      endif

      nnoremap  <silent>   <tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bnext<CR>
      nnoremap  <silent> <s-tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bprevious<CR>
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
