title: mac下sed命令-i参数
date: 2015-07-11 15:40:44
tags: 小技巧
category: Linux
---

Mac OS中的term和linux中的term还是有些不同的地方。
比如今天在用sed命令的时候，在linux中-i参数描述如下：

>-i[SUFFIX], --in-place[=SUFFIX]
>
>edit  files  in  place (makes backup if extension supplied).  The default operation mode is to break symbolic and hard links.  This can be changed with --follow-symlinks and --copy.

也就是说如果提供了后缀名，则sed命令会备份原文件，若不提供则不备份。
而在Mac OS中则必须提供这个后缀名：

>-i extension
>
>Edit files in-place, saving backups with the specified extension.  If a zero-length extension is given, no backup will be saved.  It is not recommended to give a zero-length extension when in-place editing files, as you risk corruption or partial content in situations where disk space is
    exhausted, etc.

所以Mac OS sed命令的一般用法就是：
```
sed -i [suffix] [pattern] files
```
