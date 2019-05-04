scriptencoding utf-8

" {{{ General settings
" The following are some sensible defaults for Vim for most users.
" We attempt to change as little as possible from Vim's defaults,
" deviating only where it makes sense
set nocompatible        " Use Vim defaults (much better!)
set bs=2                " Allow backspacing over everything in insert mode
set ai                  " Always set auto-indenting on
set history=50          " keep 50 lines of command history
set ruler               " Show the cursor position all the time
"set rulerformat=%20(%2*%<%f%=\ %m%r\ %3l\ %c\ %p%%%)


set viminfo='20,\"500   " Keep a .viminfo file.

" Don't use Ex mode, use Q for formatting
map Q gq

" When doing tab completion, give the following files lower priority. You may
" wish to set 'wildignore' to completely ignore files, and 'wildmenu' to enable
" enhanced tab completion. These can be done in the user vimrc file.
set suffixes+=.info,.aux,.log,.dvi,.bbl,.out,.o,.lo

" When displaying line numbers, don't use an annoyingly wide number column. This
" doesn't enable line numbers -- :set number will do that. The value given is a
" minimum width to use for the number column, not a fixed size.
if v:version >= 700
  set numberwidth=3
endif
" }}}

" {{{ Modeline settings
" We don't allow modelines by default. See bug #14088 and bug #73715.
" If you're not concerned about these, you can enable them on a per-user
" basis by adding "set modeline" to your ~/.vimrc file.
set nomodeline
" }}}

" {{{ Locale settings
" Try to come up with some nice sane GUI fonts. Also try to set a sensible
" value for fileencodings based upon locale. These can all be overridden in
" the user vimrc file.
"if v:lang =~? "^ko"
"  set fileencodings=euc-kr
"  set guifontset=-*-*-medium-r-normal--16-*-*-*-*-*-*-*
"elseif v:lang =~? "^ja_JP"
"  set fileencodings=euc-jp
"  set guifontset=-misc-fixed-medium-r-normal--14-*-*-*-*-*-*-*
"elseif v:lang =~? "^zh_TW"
"  set fileencodings=big5
"  set guifontset=-sony-fixed-medium-r-normal--16-150-75-75-c-80-iso8859-1,-taipei-fixed-medium-r-normal--16-150-75-75-c-160-big5-0
"elseif v:lang =~? "^zh_CN"
"  set fileencodings=gb2312
"  set guifontset=*-r-*
"endif

" If we have a BOM, always honour that rather than trying to guess.
"if &fileencodings !~? "ucs-bom"
"  set fileencodings^=ucs-bom
"endif

" Always check for UTF-8 when trying to determine encodings.
"if &fileencodings !~? "utf-8"
"  set fileencodings+=utf-8
"endif

" Make sure we have a sane fallback for encoding detection
set fileencodings+=default
" }}}

" {{{ Syntax highlighting settings
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
"if &t_Co > 2 || has("gui_running")
"  syntax on
"  set hlsearch
"endif
" }}}

" {{{ Terminal fixes
if &term ==? "xterm"
  set t_Sb=^[4%dm
  set t_Sf=^[3%dm
  set ttymouse=xterm2
endif

if &term ==? "gnome" && has("eval")
  " Set useful keys that vim doesn't discover via termcap but are in the
  " builtin xterm termcap. See bug #122562. We use exec to avoid having to
  " include raw escapes in the file.
  exec "set <C-Left>=\eO5D"
  exec "set <C-Right>=\eO5C"
endif
" }}}

" {{{ Filetype plugin settings
" Enable plugin-provided filetype settings, but only if the ftplugin
" directory exists (which it won't on livecds, for example).
"if isdirectory(expand("$VIMRUNTIME/ftplugin"))
"  filetype plugin on

  " Uncomment the next line (or copy to your ~/.vimrc) for plugin-provided
  " indent settings. Some people don't like these, so we won't turn them on by
  " default.
  " filetype indent on
"endif
" }}}

" {{{ Fix &shell, see bug #101665.
if "" == &shell
  if executable("/bin/bash")
    set shell=/bin/bash
  elseif executable("/bin/sh")
    set shell=/bin/sh
  endif
endif
"}}}

" {{{ Our default /bin/sh is bash, not ksh, so syntax highlighting for .sh
" files should default to bash. See :help sh-syntax and bug #101819.
if has("eval")
  let is_bash=1
endif
" }}}

" {{{ Autocommands
if has("autocmd")

augroup gentoo
  au!

  " Gentoo-specific settings for ebuilds.  These are the federally-mandated
  " required tab settings.  See the following for more information:
  " http://www.gentoo.org/proj/en/devrel/handbook/handbook.xml
  " Note that the rules below are very minimal and don't cover everything.
  " Better to emerge app-vim/gentoo-syntax, which provides full syntax,
  " filetype and indent settings for all things Gentoo.
  au BufRead,BufNewFile *.e{build,class} let is_bash=1|setfiletype sh
  au BufRead,BufNewFile *.e{build,class} set ts=4 sw=4 noexpandtab

  " In text files, limit the width of text to 78 characters, but be careful
  " that we don't override the user's setting.
  autocmd BufNewFile,BufRead *.txt
        \ if &tw == 0 && ! exists("g:leave_my_textwidth_alone") |
        \     setlocal textwidth=78 |
        \ endif

  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
        \ if ! exists("g:leave_my_cursor_position_alone") |
        \     if line("'\"") > 0 && line ("'\"") <= line("$") |
        \         exe "normal g'\"" |
        \     endif |
        \ endif

  " When editing a crontab file, set backupcopy to yes rather than auto. See
  " :help crontab and bug #53437.
  autocmd FileType crontab set backupcopy=yes

augroup END

endif " has("autocmd")
" }}}

" {{{ vimrc.local
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif
" }}}

" vim: set fenc=utf-8 tw=80 sw=2 sts=2 et foldmethod=marker :


let mapleader=","

""""""""""""""""""""""""""""""
" Tag list (ctags)
" """"""""""""""""""""""""""""""
let Tlist_Ctags_Cmd = '/usr/bin/ctags'
let Tlist_Show_One_File = 1 "不同时显示多个文件的tag，只显示当前文件的
let Tlist_Exit_OnlyWindow = 1 "如果taglist窗口是最后一个窗口，则退出vim
let Tlist_Use_Right_Window = 1 "在右侧窗口中显示taglist窗口 
 
""""""""""""""""""""""""""""""
"暂时对winManger 插件失去兴趣了
" winManager setting
" """"""""""""""""""""""""""""""
"let g:winManagerWindowLayout = "minibufexpl,FileExplorer|TagList"
let g:winManagerWindowLayout = "FileExplorer|TagList"
let g:winManagerWidth = 30
let g:defaultExplorer = 0
nmap <C-W><C-F> :FirstExplorerWindow<cr>
nmap <C-W><C-B> :BottomExplorerWindow<cr>
nmap <silent> <leader>wm :WMToggle<cr> 

""""""""""""""""""""""""""""""
" 已经使用fuzzyfinder代替
" lookupfile setting
" """"""""""""""""""""""""""""""
"let LookupFile_MinPatLength = 2               "最少输入2个字符才开始查找
"let LookupFile_PreserveLastPattern = 0        "不保存上次查找的字符串
"let LookupFile_PreservePatternHistory = 1     "保存查找历史
"let LookupFile_AlwaysAcceptFirst = 1          "回车打开第一个匹配项目
"let LookupFile_AllowNewFiles = 0              "不允许创建不存在的文件
  


filetype plugin indent on 
"对c cpp文件缩进设置
autocmd FileType c,cc,cpp,cu,cuda,python,sh,py set shiftwidth=4 | set expandtab 
autocmd FileType c,cc,cpp,cu,cuda  map <buffer> <leader><space> :w<cr>:make<cr>
"quickfix
nmap <leader>cn :cn<cr>
nmap <leader>cp :cp<cr>
nmap <leader>cw :cw<cr> 

"run command first:ctags --fields=+iaS --extra=+q -R -f ~/.vim/systags /usr/include /usr/local/include
set tags=tags;,.tags
set tags+=~/systags
"nmap <leader>ct :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<cr>
nmap <leader>ct :!ctags -I __THROW --file-scope=yes --langmap=c:+.h --languages=c,c++ --links=yes --c-kinds=+p --fields=+S  -R -f ./tags /usr/include /usr/local/include <cr>

set number


" 快捷输入
" " 自动完成括号和引号
inoremap <leader>1 ()<esc>:let leavechar=";"<cr>i
inoremap <leader>2 []<esc>:let leavechar="]"<cr>i
inoremap <leader>3 {}<esc>:let leavechar="}"<cr>i
inoremap <leader>4 {<esc>o}<esc>:let leavechar="}"<cr>O
inoremap <leader>5 <><esc>:let leavechar=">"<cr>i
inoremap <leader>q ''<esc>:let leavechar="'"<cr>i
inoremap <leader>w ""<esc>:let leavechar='"'<cr>i
inoremap <leader>i #include <><esc>:let leavechar=">"<cr>i
inoremap <leader>I #include ""<esc>:let leavechar="\""<cr>i
inoremap <leader>m int main(int args, char** argv)<esc>o{<esc>oreturn 0;<esc>o}<esc>k:let leavechar="}"<cr>O
inoremap <leader>p #!/usr/bin/python<esc>o#coding=utf8<esc>o
inoremap <leader>std using namespace std;<esc>o 
"对于新建的.h文件，自动加入宏信息
func! InsertPrepro()
	exe "normal i#ifndef _".expand("%:t:r")."_H"
	exe "normal 1bgUw$"
	exe "normal o#define _".expand("%:t:r")."_H"
	exe "normal 1bgUw$"
	exe "normal o#endif//_".expand("%:t:r")."_H"
	exe "normal 1bgUw$"
	exe "normal O"
endfunc
autocmd BufNewFile *.h :call InsertPrepro()
autocmd BufNewFile *.hpp :call InsertPrepro()

"设置编码
set fileencodings=utf8,gbk,big5,gb2312,gb18030
set pastetoggle=<F3>


"使用Doxygen Toolkit http://www.vim.org/scripts/script.php?script_id=987
let g:DoxygenToolkit_authorName="罗磊, luoleicn@gmail.com"
"let s:licenseTag = "\n*遵循知识共享（CC By2.5）协议详见\n*"
"let s:licenseTag = s:licenseTag . "http://creativecommons.org/licenses/by/2.5/cn/"
"let g:DoxygenToolkit_licenseTag = s:licenseTag
let g:DoxygenToolkit_briefTag_funcName="yes"
let g:doxygen_enhanced_color=1
let g:DoxygenToolkit_briefTag_pre="@Synopsis  " 
let g:DoxygenToolkit_paramTag_pre="@Param " 
let g:DoxygenToolkit_returnTag="@Returns   " 
let g:DoxygenToolkit_blockHeader="--------------------------------------------------------------------------" 
let g:DoxygenToolkit_blockFooter="----------------------------------------------------------------------------" 

au BufNewFile,BufRead *.cu set ft=cuda
au BufNewFile,BufRead *.cuh set ft=cuda

set nowrap
set showcmd
set incsearch
set ignorecase
syntax on
set hlsearch
"set cursorline
"set cursorcolumn

" Allow backgrounding buffers without writing them, and remember marks/undo
" for backgrounded buffers
set hidden

" 光标移动到buffer的顶部和底部时保持3行距离
set scrolloff=3
" clear the search buffer when hitting return
:nnoremap <CR> :nohlsearch<cr>

" 在被分割的窗口间显示空白，便于阅读
set fillchars=vert:\ ,stl:\ ,stlnc:\

" 我的状态行显示的内容（包括文件类型和解码）
"set statusline=%F%m%r%h%w\[POS=%l,%v][%p%%]\%{strftime(\"%d/%m/%y\ -\ %H:%M\")}
" 总是显示状态行
set laststatus=2
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ [%{(&fenc==\"\"?&enc:&fenc).(&bomb?\",BOM\":\"\")}]\ %l:%c\ \(%p%%\)%)



" Run a python script
function! ExecutePythonScript()
    if &filetype != 'python'
        echohl WarningMsg | echo 'This is not a Python file !' | echohl None
        return
    endif
    setlocal makeprg=python\ -u\ %
    set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
    echohl WarningMsg | echo 'Execution output:' | echohl None
    if &modified == 1
        silent write
    endif
    "silent make
    make
    clist
endfunction
au filetype python map <F5> :call ExecutePythonScript()<CR>
au filetype python imap <F5> <ESC>:call ExecutePythonScript()<CR>

set t_Co=256
colorscheme wombat256mod

set smartcase

map <leader>f :CommandTFlush<cr>\|:CommandT<cr>

map <silent> <F9> :TlistToggle<cr> 

" Copy from http://amix.dk/vim/vimrc.html

set wildmenu
set wildignore=*.o,*~,*.pyc

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500


" gutentags 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']

" 所生成的数据文件的名称
let g:gutentags_ctags_tagfile = '.tags'

" 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags

" 配置 ctags 的参数
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']


" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%


" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

Plug 'Valloric/YouCompleteMe'
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
Plug 'ludovicchabant/vim-gutentags'
Plug 'wincent/command-t'
Plug 'rosenfeld/conque-term'
Plug 'bfrg/vim-cuda-syntax'
Plug 'airblade/vim-gitgutter'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'
Plug 'majutsushi/tagbar'

Plug 'vim-scripts/vim-addon-mw-utils'
Plug 'vim-scripts/google.vim'
Plug 'vim-scripts/DoxygenToolkit.vim'
Plug 'vim-scripts/The-NERD-Commenter'
Plug 'vim-scripts/a.vim'
Plug 'vim-scripts/genutils'
Plug 'vim-scripts/lookupfile'
Plug 'vim-scripts/taglist.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tacahiroy/ctrlp-funky'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'

" Unmanaged plugin (manually installed and updated)
" Plug '~/my-prototype-plugin'


" Initialize plugin system
call plug#end()

" let g:ycm_global_ycm_extra_conf = '~/.vim/plugged/YouCompleteMe/.ycm_extra_conf.py'
let g:ycm_global_ycm_extra_conf = '~/.vim/plugged/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py'
" let g:ycm_global_ycm_extra_conf = '~/.vim/./plugged/YouCompleteMe/third_party/ycmd/examples/.ycm_extra_conf.py'
nnoremap <leader>gl :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>gf :YcmCompleter GoToDefinition<CR>
nnoremap <leader>gg :YcmCompleter GoToDefinitionElseDeclaration<CR>

let g:ycm_enable_diagnostic_signs = 0
let g:ycm_enable_diagnostic_highlighting = 0

"ctrlp :
"
"<leader>f   # 模糊搜索最近打开的文件(MRU)
"<leader>p   # 模糊搜索当前目录及其子目录下的所有文件
"ctrl + j/k  # 进行上下选择
"ctrl + x    # 在当前窗口水平分屏打开文件
"ctrl + v    # 同上, 垂直分屏
"ctrl + t    # 在tab中打开
"F5          # 刷新可搜索文件
"<c-d>       # 只能搜索全路径文件
"<c-r>       # 可以使用正则搜索文件
let g:ctrlp_map = '<leader>p'
let g:ctrlp_cmd = 'CtrlP'
map <leader>f :CtrlPMRU<CR>
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn|rvm)$',
    \ 'file': '\v\.(exe|so|dll|zip|tar|tar.gz|pyc)$',
    \ }
let g:ctrlp_working_path_mode=0
let g:ctrlp_match_window_bottom=1
let g:ctrlp_max_height=15
let g:ctrlp_match_window_reversed=0
let g:ctrlp_mruf_max=500
let g:ctrlp_follow_symlinks=1
nnoremap <Leader>b :CtrlPBuffer<Cr>


"CtrlPFunky
"
"<leader>fu      # 进入当前文件的函数列表搜索
"<leader>fU      # 搜索当前光标下单词对应的函数
nnoremap <Leader>fu :CtrlPFunky<Cr>
nnoremap <Leader>fU :execute 'CtrlPFunky ' . expand('<cword>')<Cr>
let g:ctrlp_funky_syntax_highlight = 1
let g:ctrlp_extensions = ['funky']

"vim-airline
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 0


"TODO: to be removed
"映射LUBufs为,lb, 在MiniBuf中找
"nmap <silent> <leader>lb :LUBufs<cr>
""在文件目录中找
"nmap <silent> <leader>lw :LUWalk<cr>
"let g:miniBufExplMapWindowNavArrows = 1
"let g:miniBufExplMapWindowNavVim = 1 
"let g:miniBufExplMapWindowNavArrows = 1 
"let g:miniBufExplMapCTabSwitchBufs = 1 
"let g:miniBufExplModSelTarget = 1 
