title: 在WordPress中插入数学公式
id: 224
categories:
  - 插件
date: 2014-09-09 20:30:47
tags:
---

[toc]

## 前言

前段时间在写自己看论文的感想时需要在blog中插入数学公式，但是WordPress的编辑器中没有数学公式的插入方法，一开始我想的是截图后插入图片，显然这样做实在太麻烦。之后我在网上找了找，发现可以使用latex显示数学公式。具体步骤如下：

## 安装一个Latex插件

现在在WordPress中支持Latex的方法主要有两种：
<!--more -->

*   一种是将Latex公式自动通过在线服务器转换成gif图片，例如[minetex](http://tex.72pines.com/latex.php)、[WordPress自带的latex服务器](http://l.wordpress.com/latex.php)、[google的latex服务器](http://chart.apis.google.com/chart?cht=tx&amp;chl=\alpha\geq\frac{\beta}{\sum%20a})。
*   一种是在WordPress中使用javascript通过位置控制、字体、大小来显示一个公式，它可以直接在前台处理。
WordPress中的Latex插件很多，在这里向大家推荐[Latex for WordPress](http://wordpress.org/extend/plugins/latex/)，该插件可以使用上述两种方法显示Latex公式，具体使用方法可以参考[插件作者的主页](http://zhiqiang.org/blog/it/latex-for-wordpress.html)。

## 编写Latex公式

Latex虽说可以完美的显示各种公式，但是其复杂的语法实在让人没有书写的欲望，这里有两种很方便的Latex编辑器：

*   一种是自制或在线Latex编辑器，例如[一个Latex自动生成器](http://www.lucienevans.com/wp-content/latex_generator/latex.htm),转自[http://www.ruanyifeng.com/webapp/formula.html](http://www.ruanyifeng.com/webapp/formula.html)，或者[http://zh.numberempire.com/texequationeditor/equationeditor.php](http://zh.numberempire.com/texequationeditor/equationeditor.php)
*   一种是专业的Latex编辑器，例如TexMaths、Texmaker等。
其实有一种更常用更简单的方法，就是使用著名的MathType编辑Latex公式，在MathType中设置选项——&gt;剪贴和复制选项如下：

[![](http://www.lucienevans.com/wp-content/uploads/2014/09/MathType设置.png)](http://www.lucienevans.com/wp-content/uploads/2014/09/MathType设置.png)

&nbsp;

之后像我们在Word中一样编辑数学公式，再直接复制即可！PS：MathType复制的公式默认是\[\]，即另起一行并居中！

到此为止，我们就可以很方便的在WordPress中插入数学公式了！Have a fun！

&nbsp;

&nbsp;
