title: Ubuntu自定义命令
tags:
  - 小技巧
id: 235
categories:
  - Linux
date: 2014-09-14 16:14:36
---

有的时候我们希望在终端中输入尽量短的命令来完成尽量多的任务，比如说“cd home/workspace”，Ubuntu中自定义命令可以有几种方法：

1.  直接在终端中输入“alias ws="cd home/workspace"”，这种方法在重启机器后失效。
2.  编辑所用的shell配置文件“vi ~/.bashrc”，在文件中加入“alias ws="cd home/workspace"”，在重新加载配置文件“source ~/.bashrc”，这里也可以将命令写入一个shell脚本里。
3.  将可执行文件目录加入PATH，创建存放自定义命令的目录，如my_cmd;将该目录加入path中，编辑所用的 shell 配置文件“vi ~/.bashrc”，加入“PATH=$PATH:~/my_cmd”，重载该配置文件使更改生效“ source ~/.bashrc”，将自定义的可执行程序放入 my_cmd 中，在 shell 就可以直接执行了。
