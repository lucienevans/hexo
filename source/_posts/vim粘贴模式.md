title: vim粘贴模式
date: 2015-07-11 15:59:39
tags: 小技巧
category: Linux Vim
---

用Vim粘贴的时候总是会出现很奇怪的制表符，从而使粘贴的格式非常乱，为了避免这种情况，可以：
>:set noai nosi

取消了自动缩进和智能缩进，这样粘贴就不会错行了。但在有的vim中不行，还是排版错乱。

后来发现了更好用的设置：
>:set paste

进入paste模式以后，可以在插入模式下粘贴内容，不会有任何变形。这个真是灰常好用，情不自禁看了一下帮助，发现它做了这么多事：
<!-- more -->

textwidth设置为0
wrapmargin设置为0
set noai
set nosi
softtabstop设置为0
revins重置
ruler重置
showmatch重置
formatoptions使用空值

下面的选项值不变，但却被禁用：

lisp
indentexpr
cindent
怪不得之前只设置noai和nosi不行，原来与这么多因素有关！

但这样还是比较麻烦的，每次要粘贴的话，先set paste，然后粘贴，然后再set nopaste。有没有更方便的呢？你可能想到了，使用键盘映射呀，对。我们可以这样设置：:
>:map <F10> :set paste<CR>
>:map <F11> :set nopaste<CR>

这样在粘贴前按F10键启动paste模式，粘贴后按F11取消paste模式即可。其实，paste有一个切换paste开关的选项，这就是pastetoggle。通过它可以绑定快捷键来激活/取消 paste模式。比如：:
>:set pastetoggle=<F11>

这样减少了一个快捷键的占用，使用起来也更方便一些。

原文转自：http://blog.csdn.net/king_on/article/details/8104235
