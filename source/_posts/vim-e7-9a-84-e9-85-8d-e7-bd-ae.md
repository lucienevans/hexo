title: Vim的配置
tags:
  - 配置文件
id: 257
categories:
  - Vim
date: 2014-09-30 17:33:52
---

最近在Ubuntu上学习Python，使用Vim来编写。早就对Vim有所耳闻，刚开始使用的确体验不好，在网上搜了搜Vim的配置文件和插件，再用起来感觉好多了，这里backup一下：
<!--more-->
<pre class="lang:default decode:true ">"winpos 5 5          " 设定窗口位置  
"set lines=40 columns=155    " 设定窗口大小  
"set nu              " 显示行号  
set go=             " 不要图形按钮  
"color asmanian2     " 设置背景主题  
set guifont=Courier_New:h10:cANSI   " 设置字体  
"syntax on           " 语法高亮  
autocmd InsertLeave * se nocul  " 用浅色高亮当前行  
autocmd InsertEnter * se cul    " 用浅色高亮当前行  
"set ruler           " 显示标尺  
set showcmd         " 输入的命令显示出来，看的清楚些  
"set cmdheight=1     " 命令行（在状态行下）的高度，设置为1  
"set whichwrap+=&lt;,&gt;,h,l   " 允许backspace和光标键跨越行边界(不建议)  
"set scrolloff=3     " 光标移动到buffer的顶部和底部时保持3行距离  
set novisualbell    " 不要闪烁(不明白)  
set statusline=%F%m%r%h%w\ [FORMAT=%{&amp;ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}   "状态行显示的内容  
set laststatus=1    " 启动显示状态行(1),总是显示状态行(2)  
set foldenable      " 允许折叠  
set foldmethod=manual   " 手动折叠  
"set background=dark "背景使用黑色 
set nocompatible  "去掉讨厌的有关vi一致性模式，避免以前版本的一些bug和局限  
" 显示中文帮助
if version &gt;= 603
	set helplang=cn
	set encoding=utf-8
endif
" 设置配色方案
"colorscheme murphy
"字体 
"if (has("gui_running")) 
"   set guifont=Bitstream\ Vera\ Sans\ Mono\ 10 
"endif 
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936
set fileencoding=utf-8
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""新文件标题""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"新建.c,.h,.sh,.java文件，自动插入文件头 
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.java,*.py exec ":call SetTitle()"
"定义函数SetTitle，自动插入文件头 
func SetTitle() 
	"如果文件类型为.sh文件 
	if &amp;filetype == 'sh' 
		call setline(1,"\#########################################################################") 
		call append(line("."), "\# File Name: ".expand("%")) 
		call append(line(".")+1, "\# Author: lucien") 
		call append(line(".")+2, "\# mail: admin@lucienevans.com") 
		call append(line(".")+3, "\# Created Time: ".strftime("%c")) 
		call append(line(".")+4, "\#########################################################################") 
		call append(line(".")+5, "\#!/bin/bash") 
		call append(line(".")+6, "") 
	elseif &amp;filetype == 'python' 
		call setline(1,"\#!/usr/bin/python") 
		call append(line("."), "\#coding:utf-8")
		call append(line(".")+1, "\#File Name: ".expand("%"))
		call append(line(".")+2, "\#Author: lucien") 
		call append(line(".")+3, "\#Mail: admin@lucienevans.com ") 
		call append(line(".")+4, "\#Created Time: ".strftime("%c")) 
		call append(line(".")+5, "")
	else 
		call setline(1, "/*************************************************************************") 
		call append(line("."), "File Name: ".expand("%")) 
		call append(line(".")+1, "Author: lucien") 
		call append(line(".")+2, "Mail: admin@lucienevans.com ") 
		call append(line(".")+3, "Created Time: ".strftime("%c")) 
		call append(line(".")+4, " ************************************************************************/") 
		call append(line(".")+5, "")
	endif
	if &amp;filetype == 'cpp'
		call append(line(".")+6, "#include&lt;iostream&gt;")
		call append(line(".")+7, "using namespace std;")
		call append(line(".")+8, "")
	endif
	if &amp;filetype == 'c'
		call append(line(".")+6, "#include&lt;stdio.h&gt;")
		call append(line(".")+7, "")
	endif
	"新建文件后，自动定位到文件末尾
	autocmd BufNewFile * normal G
endfunc 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"键盘命令
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap &lt;leader&gt;w :w!&lt;cr&gt;
nmap &lt;leader&gt;f :find&lt;cr&gt;
" 映射全选+复制 ctrl+a
map &lt;C-A&gt; ggVGY
map! &lt;C-A&gt; &lt;Esc&gt;ggVGY
map &lt;F12&gt; gg=G
" 选中状态下 Ctrl+c 复制
vmap &lt;C-c&gt; "+y
"撤销
imap &lt;C-z&gt; &lt;ESC&gt;ui
"反撤销
imap &lt;C-y&gt; &lt;ESC&gt;&lt;C-r&gt;i
"自动补全
imap j &lt;C-X&gt;&lt;C-O&gt;  "这里没有显示出j前面的字符，应该是Ctrl+v然后再Alt+j
"删除一行
imap &lt;C-d&gt; &lt;ESC&gt;ddi
"去空行  
nnoremap &lt;F2&gt; :g/^\s*$/d&lt;CR&gt; 
"比较文件  
nnoremap &lt;C-F2&gt; :vert diffsplit 
"C，C++ 按F5编译运行
map &lt;F5&gt; :call CompileRunGcc()&lt;CR&gt;
func! CompileRunGcc()
	exec "w"
	if &amp;filetype == 'c'
		exec "!g++ % -o %&lt;"
		exec "! ./%&lt;"
	elseif &amp;filetype == 'cpp'
		exec "!g++ % -o %&lt;"
		exec "! ./%&lt;"
	elseif &amp;filetype == 'java' 
		exec "!javac %" 
		exec "!java %&lt;"
	elseif &amp;filetype == 'sh'
		:!./%
	endif
endfunc
"C,C++的调试
map &lt;F8&gt; :call Rungdb()&lt;CR&gt;
func! Rungdb()
	exec "w"
	exec "!g++ % -g -o %&lt;"
	exec "!gdb ./%&lt;"
endfunc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""实用设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 设置当文件被改动时自动载入
set autoread
" quickfix模式
autocmd FileType c,cpp map &lt;buffer&gt; &lt;leader&gt;&lt;space&gt; :w&lt;cr&gt;:make&lt;cr&gt;
"代码补全 
set completeopt=preview,menu 
"允许插件  
filetype plugin on
""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""python补全"""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType python set omnifunc=pythoncomplete#Complete 
"共享剪贴板  
set clipboard+=unnamed 
"从不备份  
set nobackup
"make 运行
:set makeprg=g++\ -Wall\ \ %
"自动保存
set autowrite
set ruler                   " 打开状态栏标尺
"set cursorline              " 突出显示当前行
set magic                   " 设置魔术
"set guioptions-=T           " 隐藏工具栏
"set guioptions-=m           " 隐藏菜单栏
"set statusline=\ %&lt;%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&amp;fileformat}\ %{&amp;encoding}\ %c:%l/%L%)\
" 设置在状态行显示的信息
set foldcolumn=0
set foldmethod=indent 
set foldlevel=3 
set foldenable              " 开始折叠
" 不要使用vi的键盘模式，而是vim自己的
set nocompatible
" 语法高亮
set syntax=on
" 去掉输入错误的提示声音
set noeb
" 在处理未保存或只读文件的时候，弹出确认
set confirm
" 自动缩进
set autoindent
set cindent
" Tab键的宽度
set tabstop=4
" 统一缩进为4
set softtabstop=4
set shiftwidth=4
" 不要用空格代替制表符
set noexpandtab
" 在行和段开始处使用制表符
set smarttab
" 显示行号
set number
" 历史记录数
set history=1000
"禁止生成临时文件
set nobackup
set noswapfile
"搜索忽略大小写
set ignorecase
"搜索逐字符高亮
set hlsearch
set incsearch
"行内替换
set gdefault
"编码设置
set enc=utf-8
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936
"语言设置
set langmenu=zh_CN.UTF-8
set helplang=cn
" 我的状态行显示的内容（包括文件类型和解码）
"set statusline=%F%m%r%h%w\ [FORMAT=%{&amp;ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
"set statusline=[%F]%y%r%m%*%=[Line:%l/%L,Column:%c][%p%%]
" 总是显示状态行
set laststatus=2
" 命令行（在状态行下）的高度，默认为1，这里是2
set cmdheight=2
" 侦测文件类型
filetype on
" 载入文件类型插件
filetype plugin on
" 为特定文件类型载入相关缩进文件
filetype indent on
" 保存全局变量
set viminfo+=!
" 带有如下符号的单词不要被换行分割
set iskeyword+=_,$,@,%,#,-
" 字符间插入的像素行数目
set linespace=0
" 增强模式中的命令行自动完成操作
set wildmenu
" 使回格键（backspace）正常处理indent, eol, start等
set backspace=2
" 允许backspace和光标键跨越行边界
set whichwrap+=&lt;,&gt;,h,l
" 可以在buffer的任何地方使用鼠标（类似office中在工作区双击鼠标定位）
set mouse=a
set selection=exclusive
set selectmode=mouse,key
" 通过使用: commands命令，告诉我们文件的哪一行被改变过
set report=0
" 在被分割的窗口间显示空白，便于阅读
set fillchars=vert:\ ,stl:\ ,stlnc:\
" 高亮显示匹配的括号
set showmatch
" 匹配括号高亮的时间（单位是十分之一秒）
set matchtime=1
" 光标移动到buffer的顶部和底部时保持3行距离
set scrolloff=3
" 为C程序提供自动缩进
set smartindent
" 高亮显示普通txt文件（需要txt.vim脚本）
au BufRead,BufNewFile *  setfiletype txt
"自动补全
:inoremap ( ()&lt;ESC&gt;i
:inoremap ) &lt;c-r&gt;=ClosePair(')')&lt;CR&gt;
:inoremap { {&lt;CR&gt;}&lt;ESC&gt;O
:inoremap } &lt;c-r&gt;=ClosePair('}')&lt;CR&gt;
:inoremap [ []&lt;ESC&gt;i
:inoremap ] &lt;c-r&gt;=ClosePair(']')&lt;CR&gt;
:inoremap " ""&lt;ESC&gt;i
:inoremap ' ''&lt;ESC&gt;i

function! ClosePair(char)
	if getline('.')[col('.') - 1] == a:char
		return "\&lt;Right&gt;"
	else
		return a:char
	endif
endfunction
filetype plugin indent on 
"打开文件类型检测, 加了这句才可以用智能补全
set completeopt=longest,menu</pre>
这里只使用了一个python补全插件[Pythoncomplete](http://www.vim.org/scripts/script.php?script_id=1542)，其他的CTags、TaskList都没用了，以后有时间在弄，很多插件都在[Vim官网](http://www.vim.org/)或者[GitHub](https://www.github.com/)上。
