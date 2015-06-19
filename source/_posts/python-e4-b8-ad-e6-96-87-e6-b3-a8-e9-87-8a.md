title: Python中文注释
id: 238
categories:
  - python
date: 2014-09-15 21:45:39
tags:
---

<span style="font-size: medium;">通常，python源代码必须完全由ASCII集合组成，如果直接在python中添加中文注释的时候，python执行时会引发异常，告知非ASCII字符语法错误。</span>

<span style="font-size: medium;"> SyntaxError: Non-ASCII character '/xd5' in file D:/Project/python/sort/quick_sort.py on line 9, but no encoding declared; see http://www.python.org/peps/pep-0263.html for details</span>

<span style="font-size: medium;"> 这个时候的解决方法，就是在告知python使用的编码方式，告知方法是在源文件的初始部分，也就是顶行加上这样一行注释！</span>

<span style="font-size: medium;">  #coding = utf-8或者#coding:utf-8或者# -*- coding: utf-8 -*</span>

<span style="font-size: medium;"> 这行注释的格式必须与这个保持严格一致，在coding之后输入python已知的字符编码方式，比如utf-8或iso-8859-1。该处编码一定要和文件编码一致！</span>