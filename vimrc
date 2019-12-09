scriptencoding utf-8
set encoding=utf-8

" 如果打开root文件，没有权限写入，可以调用w!!来尝试用sudo写入，不必退出后多步操作
cmap w!! w !sudo tee > /dev/null %

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

inoremap jh <Esc>

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

" Make sure we have a sane fallback for encoding detection
set fileencodings+=default
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

filetype plugin indent on 
"对c cpp文件缩进设置
"autocmd FileType c,cc,cpp,cu,cuda,python,sh,py set shiftwidth=2 | set expandtab 
autocmd FileType c,cc,cpp,cu,cuda,python,sh,py setlocal et sta sw=2 sts=2
autocmd FileType c,cc,cpp,cu,cuda  map <buffer> <leader><space> :w<cr>:make<cr>
"quickfix
nmap <leader>cn :cn<cr>
nmap <leader>cp :cp<cr>
nmap <leader>cw :cw<cr> 

"run command first:ctags --fields=+iaS --extra=+q -R -f ~/.vim/systags /usr/include /usr/local/include
set tags=tags;,.tags
set tags+=~/systags
"nmap <leader>ct :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<cr>
nmap <leader>ct :!ctags -I __THROW --file-scope=yes --langmap=c:+.cu.cuh --langmap=c++:+.cu.cuh --languages=c,c++ --links=yes --c-kinds=+p --fields=+S  -R -f ./tags /usr/include /usr/local/include <cr>

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
inoremap <leader>m int main(int args, char** argv) {<esc>o<esc>oreturn 0;<esc>o}<esc>k:let leavechar="}"<cr>O
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
let g:gutentags_ctags_extra_args += ['--langmap=c++:+.cu.cuh']
let g:gutentags_ctags_extra_args += ['--exclude=.git']
let g:gutentags_ctags_extra_args += ['--exclude=build_isolated']
let g:gutentags_ctags_extra_args += ['--exclude=devel_isolated']
let g:gutentags_ctags_extra_args += ['--exclude=install_isolated']
let g:gutentags_ctags_extra_args += ['--exclude=.cquery_cache']
let g:gutentags_ctags_extra_args += ['--exclude=build']
" 针对 Ctrl + ]对函数、元素进行跳转时控制是否进行选择： https://blog.csdn.net/Aemonair/article/details/78813823
set cscopetag


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

" Plug 'Valloric/YouCompleteMe', { 'do': 'python install.py --clang-completer' }
Plug 'zxqfl/tabnine-vim', {'do' : './install.sh'}
Plug 'ludovicchabant/vim-gutentags'
Plug 'rosenfeld/conque-term'
Plug 'bfrg/vim-cuda-syntax'
" Plug 'airblade/vim-gitgutter'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'
Plug 'majutsushi/tagbar'

Plug 'vim-scripts/vim-addon-mw-utils'
Plug 'vim-scripts/DoxygenToolkit.vim'
Plug 'vim-scripts/The-NERD-Commenter'
Plug 'vim-scripts/a.vim'
Plug 'vim-scripts/genutils'
Plug 'vim-scripts/lookupfile'
Plug 'vim-scripts/taglist.vim'
" Plug 'ctrlpvim/ctrlp.vim'
" Plug 'tacahiroy/ctrlp-funky'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'

Plug 'google/vim-searchindex'
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'
Plug 'easymotion/vim-easymotion'
Plug 'godlygeek/tabular'
" Track the engine.
Plug 'SirVer/ultisnips'
" Snippets are separated from the engine. Add this if you want them:
Plug 'honza/vim-snippets'

Plug 'iamcco/mathjax-support-for-mkdp'
Plug 'iamcco/markdown-preview.vim'

Plug 'Yggdroot/LeaderF', {'do': './install.sh'}


call plug#end()

" let g:ycm_global_ycm_extra_conf = '~/.vim/plugged/YouCompleteMe/.ycm_extra_conf.py'
let g:ycm_global_ycm_extra_conf = '~/.vim/plugged/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py'
" let g:ycm_global_ycm_extra_conf = '~/.vim/./plugged/YouCompleteMe/third_party/ycmd/examples/.ycm_extra_conf.py'
nnoremap <leader>gl :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>gf :YcmCompleter GoToDefinition<CR>
nnoremap <leader>gg :YcmCompleter GoToDefinitionElseDeclaration<CR>

let g:ycm_enable_diagnostic_signs = 0
let g:ycm_enable_diagnostic_highlighting = 0
set completeopt=menu,menuone
let g:ycm_add_preview_to_completeopt = 0

set rtp+=~/.vim/plugged/tabnine-vim


""ctrlp :
""
""<leader>f   # 模糊搜索最近打开的文件(MRU)
""<leader>p   # 模糊搜索当前目录及其子目录下的所有文件
""ctrl + j/k  # 进行上下选择
""ctrl + x    # 在当前窗口水平分屏打开文件
""ctrl + v    # 同上, 垂直分屏
""ctrl + t    # 在tab中打开
""F5          # 刷新可搜索文件
""<c-d>       # 只能搜索全路径文件
""<c-r>       # 可以使用正则搜索文件
"let g:ctrlp_map = '<leader>p'
"let g:ctrlp_cmd = 'CtrlP'
"map <leader>f :CtrlPMRU<CR>
"let g:ctrlp_custom_ignore = {
"    \ 'dir':  '\v[\/]\.(git|hg|svn|rvm)$',
"    \ 'file': '\v\.(exe|so|dll|zip|tar|tar.gz|pyc)$',
"    \ }
"let g:ctrlp_working_path_mode=0
"let g:ctrlp_match_window_bottom=1
"let g:ctrlp_max_height=15
"let g:ctrlp_match_window_reversed=0
"let g:ctrlp_mruf_max=500
"let g:ctrlp_follow_symlinks=1
"let g:ctrlp_clear_cache_on_exit = 1
"nnoremap <Leader>b :CtrlPBuffer<Cr>
"
"
""CtrlPFunky
""
""<leader>fu      # 进入当前文件的函数列表搜索
""<leader>fU      # 搜索当前光标下单词对应的函数
"nnoremap <Leader>fu :CtrlPFunky<Cr>
"nnoremap <Leader>fU :execute 'CtrlPFunky ' . expand('<cword>')<Cr>
"let g:ctrlp_funky_syntax_highlight = 1
"let g:ctrlp_extensions = ['funky']

"vim-airline
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 0


"codefmt
call glaive#Install()
"binding <leader>=
Glaive codefmt plugin[mappings]
Glaive codefmt clang_format_style="google"

"comment
"<leader>cc 注释当前行
"<leader>cm 只用一组符号来注释
"<leader>cy 注释并复制
"<leader>cs 优美的注释
"<leader>cu 取消注释

"删除缓存区
":bdelete num如bdelete 1删除第一个缓存区
":1,3 bdelete 删除缓存区1到3
":% bdelete 删除所有缓存区

"easymotion相关http://wklken.me/posts/2015/06/07/vim-plugin-easymotion.html

" ultisnips
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsListSnippets="<c-l>"
let g:UltiSnipsJumpForwardTrigger="<c-k>"
let g:UltiSnipsJumpBackwardTrigger="<c-j>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" markdown 文档
" https://github.com/iamcco/markdown-preview.vim/blob/master/README_cn.md

" leaderF
" don't show the help in normal mode
let g:Lf_HideHelp = 1
let g:Lf_UseCache = 0
let g:Lf_UseVersionControlTool = 0
let g:Lf_IgnoreCurrentBufferName = 1
" popup mode
let g:Lf_WindowPosition = 'popup'
let g:Lf_PreviewInPopup = 1
"let g:Lf_PreviewResult = {'Function': 0, 'BufTag': 0 }
let g:Lf_ShortcutF = "<leader>p"
noremap <leader>b :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
noremap <leader>r :<C-U><C-R>=printf("Leaderf rg %s", "")<CR><CR>
noremap <leader>f :<C-U><C-R>=printf("Leaderf function %s", "")<CR><CR>
noremap <leader>fm :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>
noremap <leader>ft :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>
noremap <leader>fl :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>
" search visually selected text literally
xnoremap gf :<C-U><C-R>=printf("Leaderf! rg -F -e %s ", leaderf#Rg#visual())<CR>
noremap go :<C-U>Leaderf! rg --recall<CR>
" should use `Leaderf gtags --update` first
let g:Lf_GtagsAutoGenerate = 0
" let g:Lf_Gtagslabel = 'native-pygments'
" noremap <leader>fr :<C-U><C-R>=printf("Leaderf! gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>
" noremap <leader>fd :<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
" noremap <leader>fo :<C-U><C-R>=printf("Leaderf! gtags --recall %s", "")<CR><CR>
" noremap <leader>fn :<C-U><C-R>=printf("Leaderf gtags --next %s", "")<CR><CR>
" noremap <leader>fp :<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>

