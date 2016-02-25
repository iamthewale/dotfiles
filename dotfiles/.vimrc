" .vimrc

" Load up pathogen and all bundles
call pathogen#infect()
call pathogen#helptags()

set nocompatible " Don't need to be compatible with old vim
set nocompatible
if has("autocmd")
  filetype plugin indent on
endif
syntax on " Show syntax highlighting
set ignorecase " Ignore case in search
set hlsearch " Highlight all search matches
set cursorline " Highlight current line
set scrolloff=2 " Minimum lines above&below cursor
set nofoldenable " Disable code folding
" set clipboard=unnamed " Use the system clipboard
set laststatus=2 " Always show status bar
set noshowmode " Airline plugin is already showing the mode
set thesaurus+=/Users/Witek/.vim/thesaurus/mthesaur.txt
set nu

" Setting tabs to 2 spaces (for Ruby)
set tabstop=2
set softtabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Space as the leader key
" let mapleader = "\<Space>"

" Highlight the status bar when in insert mode
if version >= 700
  au InsertEnter * hi StatusLine ctermfg=235 ctermbg=2
  au InsertLeave * hi StatusLine ctermbg=240 ctermfg=12
endif

" Remapping of plugins and functions
" Open NERDTree
noremap <Leader>o :NERDTreeToggle<CR>
" Launch Goyo writing mode
noremap <Leader>g :Goyo<CR>
" Launch EasyMotion
nmap <Leader>w <Plug>(easymotion-s)
" Rename file
map <leader>n :call RenameFile()<cr>
" Execute file
map <leader>e :call ExecuteFile(expand("%"))<cr>
" Launch thesaurus
nnoremap <Leader>t :OnlineThesaurusCurrentWord<CR>
let g:EasyMotion_do_mapping = 0 " Disable default mappings
let g:vim_markdown_folding_disabled = 0 " Disable folding in Markdown
let g:EasyMotion_smartcase = 1 " Turn on case sensitive feature

" Airline configuration
let g:airline_powerline_fonts = 1
let g:airline_section_c = '%t'
let g:airline_theme = 'pencil'
let g:airline#extensions#whitespace#enabled = 0

" Lexical configuration
let g:lexical#spell_key = '<leader>s'

" CtrlP configuration
let g:ctrlp_by_filename = 0 "Search by filename, not full file path
" Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
let g:ctrlp_user_command = 'ag %s -l --nocolor -p /Users/Witek/.agignore -g ""'
" ag is fast enough that CtrlP doesn't need to cache
let g:ctrlp_use_caching = 0
" let g:ctrlp_custom_ignore = {
" \ 'path': $HOME.'/\(Library\|Music\)$',
" \ 'file': '\.pdf$\|\.doc$|\.docx$|\.rtf$|\.jpg$|\.pages$|\.soulver$|\.scap$|\.dll$'
" \ }
" Quick Scope configuration
let g:qs_enable = 0
let g:qs_enable_char_list = [ 'f', 'F', 't', 'T' ]

function! Quick_scope_selective(movement)
    let needs_disabling = 0
    if !g:qs_enable
        QuickScopeToggle
        redraw
        let needs_disabling = 1
    endif
    let letter = nr2char(getchar())
    if needs_disabling
        QuickScopeToggle
    endif
    return a:movement . letter
endfunction

for i in g:qs_enable_char_list
	execute 'noremap <expr> <silent>' . i . " Quick_scope_selective('". i . "')"
endfor

func! WordProcessorMode()
	map j gj
	map k gk
	set formatprg=par
    " setlocal formatoptions=ant
    " setlocal textwidth=80
    " setlocal wrapmargin=0
    setlocal noexpandtab
	setlocal spell spelllang=en
	setlocal wrap
	setlocal linebreak
endfu
com! WP call WordProcessorMode()

func! WritingMode()
    set background=light
    set nonu
    set laststatus=1
    colorscheme pencil
    " hi FoldColumn guibg=white
    set foldcolumn=5
    set linespace=8
    set guifont=Courier\ Prime:h18
endfu
com! WritingMode call WritingMode()

syntax enable
set background=dark
colorscheme pencil

" Automatically calling pencil() when working with Markdown files
" augroup pencil
"     autocmd!
"     autocmd FileType markdown,md  call pencil#init()
"     autocmd FileType text         call pencil#init()
" augroup END

" Map markdown preview
nnoremap <leader>m :silent !open -a Marked\ 2.app '%:p'<cr>

" Force .txt files to use Markdown syntax highlighting
au BufRead,BufNewFile *.txt,*.md set filetype=markdown

" Execute file if we know how
function! ExecuteFile(filename)
  :w
  :silent !clear
  if match(a:filename, '\.py$') != -1
    exec ":!python " . a:filename
  elseif match(a:filename, '\.rb$') != -1
    exec ":!ruby " . a:filename
  elseif match(a:filename, '\.sh$') != -1
    exec ":!bash " . a:filename
  else
    exec ":!echo \"Don't know how to execute: \"" . a:filename
  end
endfunction

" Rename current file, via Gary Bernhardt
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'))
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor
endif
filetype plugin indent on
