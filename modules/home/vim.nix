{ config, pkgs, ... }:

{
  programs.vim = {
    enable = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      vim-sensible
      vim-unimpaired
      vim-fugitive
      vim-surround
      vim-repeat
      vim-github-dashboard
      nerdtree
      nerdtree-git-plugin
      vim-nerdtree-syntax-highlight
      nerdcommenter
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
      LanguageClient-neovim
      vim-numbertoggle
      rainbow
      sparkup
      vim-gutentags
      vim-cool
      undotree
    ];

    settings = {
      number = true;
      expandtab = true;
      modeline = true;
      history = 1000;
      shiftwidth = 4;
      tabstop = 4;
      background = "dark";
    };

    extraConfig = ''
      set autoindent
      set cursorline
      set nofoldenable
      set hlsearch
      set wildmenu
      set wildmode=list:longest,list:full
      set diffopt+=vertical
      set foldmethod=indent

      syntax on
      colorscheme gruvbox

      " Rainbow Parentheses Improved plugin settings:
      let g:rainbow_active = 1

      " Airline settings:
      let g:airline_theme='molokai'
      let g:airline#extensions#tabline#enabled=1
      let g:airline_powerline_fonts=1

      " Gitgutter settings:
      let g:gitgutter_set_sign_backgrounds=0

      " ALE settings:
      let b:ale_fixers = {'javascript': ['prettier', 'eslint']}
      let g:ale_fix_on_save = 1
      let g:ale_completion_enabled = 1
      let g:ale_sign_error = "✗"
      let g:ale_sign_warning = "⚠"
      let g:ale_linters = { 'rust': ['analyzer'], 'python': ['pylint', 'pylsp'], 'c': ['ccls'], 'javascript': ['flow'] }

      " Gutentags settings:
      let g:gutentags_ctags_tagfile = '.tags'
      let g:gutentags_cache_dir = expand('~/.cache/vim/ctags/')
      let g:gutentags_generate_on_new = 1
      let g:gutentags_generate_on_missing = 1
      let g:gutentags_generate_on_write = 1
      let g:gutentags_generate_on_empty_buffer = 0
      let g:gutentags_ctags_executable = '${pkgs.universal-ctags}/bin/ctags'
      set statusline+=%{gutentags#statusline()}

      " Sets the working directory to the current file's directory:
      autocmd BufEnter * lcd %:p:h

      " Show signcolumn only in certain filetypes:
      autocmd BufRead,BufNewFile * set signcolumn=yes
      autocmd FileType tagbar,nerdtree set signcolumn=no

      " DEFAULT <leader> IS '\'
      " NERDTree keybindings:
      nnoremap <leader>n :NERDTreeFocus<CR>
      nnoremap <C-t> :NERDTreeToggle<CR>

      " fzf.vim keybindings:
      nnoremap <leader>f :Files<CR>
      nnoremap <leader>b :Buffers<CR>
      nnoremap <leader>c :Commits<CR>
      nnoremap <leader>t :Tags<CR>
      nnoremap <leader>x :Commands<CR>

      " Undotree keybinding:
      nnoremap <leader>u :UndotreeToggle<CR>

      " LanguageClient keybindings:
      let g:LanguageClient_serverCommands = {
        \ 'python': ['pyls']
        \ }
      nnoremap <F5> :call LanguageClient_contextMenu()<CR>
      nnoremap <silent> gh :call LanguageClient_textDocument_hover()<CR>
      nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
      nnoremap <silent> gr :call LanguageClient_textDocument_references()<CR>
      nnoremap <silent> gs :call LanguageClient_textDocument_documentSymbol()<CR>
      nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
      nnoremap <silent> gf :call LanguageClient_textDocument_formatting()<CR>

      " Start NERDTree when vim starts with no file arguments, but do not hide default vim startup window:
      autocmd StdinReadPre * let s:std_in=1
      autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | wincmd p | endif

      " Toggle next/pref buffer with <tab> key:
      nnoremap  <silent>   <tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bnext<CR>
      nnoremap  <silent> <s-tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bprevious<CR>

      " Disable arrow keys in normal mode to encourage hjkl usage:
      noremap <Up> <NOP>
      noremap <Down> <NOP>
      noremap <Left> <NOP>
      noremap <Right> <NOP>

      if (empty($TMUX) && getenv('TERM_PROGRAM') != 'Apple_Terminal')
        if (has("nvim"))
          let $NVIM_TUI_ENABLE_TRUE_COLOR=1
        endif
      endif
    '';
  };
}
