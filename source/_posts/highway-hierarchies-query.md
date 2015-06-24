title: Highway Hierarchies Query
tags:
  - 寻路算法
  - 论文研究
id: 293
categories:
  - 交通流最短路
date: 2014-10-14 10:46:16
---

在上一篇文章[Highway Hierarchies](http://www.lucienevans.com/?p=80)中介绍了怎么构建一个图的Highway Hierarchies，我们得到了$\varsigma = (V,E \cup \cup _{i = 1}^L{S_i})$以及各层次的${V_l}$，${V'_l}$，${E_l}$，${E'_l}$，${B_l}$，${S_l}$。现在我们来研究到底怎么运用Highway Hierarchies的这些数据进行最短路的查询。

## 基本思路

公路层次查询算法（_highway query algorithm_）是双向Dijkstra算法的一个变体，所以在下面的叙述中我们只关注从起点开始的算法，从终点开始的算法与其是一样的。对于搜索时的每个点来说，除了包含起点到它的距离（Dijkstra算法所需的数据）之外，还要包含搜索到它时的网络层次以及它到当前搜索边界的距离（_<span style="color: #231f20;">the gap to the ‘next applicable neighborhood border’</span>_）。这里的gap是为了确定怎么进行下一步的搜索，具体计算方法是：
<!--more -->

1.  对每一$l$层第一个搜索的点${s_i}$来说，它的gap等于它的邻居半径（neighborhood radius）。
2.  对其他的点$v$来说，它的gap等于它的父节点$u$的gap减去$(u,v)$的长度。
当$v$的gap大于等于0时，说明我们仍然在${s_i}$的邻居内进行搜索，这时我们只需继续经典的Dijkstra算法即可；当一个点$v$的gap小于0时，我们可以判断它已经不在${s_i}$的邻居里了，这时将$v$的父节点$u$称作进入上一层网络的入口。对于$v$来说，它有可能在第$l$层网络中，也有可能在第$l+k$（k&gt;0）层网络，这需要看$(u,v)$所在的网络层次：

1.  如果$(u,v)$在第$l$层网络，我们将不对$v$进行松弛。这是因为我们的算法是双向的，而Highway Hierarchies的计算保证最短路的边的层次都是足够高的，所以我们不需要关心那些不在邻居范围内的低层次的点。这就是算法的约束1！
2.  如果$(u,v)$在第$l+k$层网络，那么我们将$v$的gap置为$v$到$u$邻居边界的距离，然后继续在第$l+k$层网络中进行Dijkstra算法。
图1表示了这一过程。

[![Query 1](http://www.lucienevans.com/wp-content/uploads/2014/10/Query-1.png)](http://7xjv88.com1.z0.glb.clouddn.com/1435115275) 图 1.公路层次查询一个简要的图示

除此之外，我们还要解决一个问题：$l$层的入口不在该层网络的核心内，而是一个绕过的点（bypassed nodes）。这时候算法会在bypassed nodes中继续进行直到第$l$层的核心点$u$到达，$u$的gap置为$u$在网络层次$l$中的邻居半径。注意：在$u$没到达之前，bypassed nodes的gap都是无穷大的。

在网络核心中我们仍然进行Dijkstra算法，但是要注意一点：当一点$u \in {V_l}'$被搜索过了，任何一条指向一个bypassed node$v \in {B_l}$的边都不会被松弛；也就是说，当我们进入一个网络核心时，就不会再离开这个核心（除非要进入上一层网络）。这就是约束2！

[![Query 2](http://www.lucienevans.com/wp-content/uploads/2014/10/Query-2.png)](http://7xjv88.com1.z0.glb.clouddn.com/1435115276) 图 2.一个搜索的详细的例子。网络层次0、1、2分别用红线、蓝线、绿线表示，淡蓝色的点表示bypassed nodes，深蓝色的点表示核心

图2演示了搜索的具体过程。搜索从起点$s$开始，$s$的gap是它在第0层网络中的邻居半径，在$s$的邻居中，我们进行标准的Dijkstra算法。点$u$跑出$s$的邻居范围了，但是$u$仍在第0层，根据约束1我们不松弛它。离开${s_1}$的边在第1层，所以我们松弛它，但是${s_1}$及其子节点都是bypassed nodes，所以它们的gap都是无穷大的。在${s_1}'$点，我们离开了bypassed nodes进入了第1层网络的核心，我们将${s_1}'$的gap置为其在第1层网络的邻居半径，并且在其邻居半径内继续进行标准的Dijkstra算法。注意点$v$没有被松弛因为$s$是一个第1层的bypassed node（根据约束2）。在${s_2}'$点，我们没有通过bypassed nodes进入第2层，而是通过一条捷径直接进入第2层的核心，然后继续在第2层的核心进行搜索算法。

## 基本算法

### 数据结构

对于图中每个点$u$我们都定义一个三元组$(\delta (u),l(u),gap(u))$，并称之为$u$的键（_key_），$\delta (u)$表示起点（或终点）到$u$的距离；$l(u)$表示搜索到$u$时的网络层次；$gap(u)$表示$u$到下一个邻居边界的距离。在优先队列中我们仅使用$\delta (u)$作为优先级的判断依据。

对于一个点来说，如果它有两个$\delta (u)$相同的key：$k: = (\delta ,l,gap)$，$k': = (\delta ,l',gap')$，那么我们更希望使用$l$更大，$gap$更小的key，也就是说若$l &gt; l'$或者$l = l' \wedge gap &lt; gap'$，我们选择k作为key。

### 算法描述

下图是基本算法的伪代码：

![捕获](http://7xjv88.com1.z0.glb.clouddn.com/1435115278)

解释：

*   Line 4：算法的正确与否和这里选择正向队列或反向队列的策略无关，但是一个好的策略是能够加快算法的速度。
*   Line 7：如果一个点的gap为$\infty $，那么这个点要么是一个不在core中的点要么是第一个进入core中的点。所以不管该点是哪一种，这样的处理都能正确的计算该点的gap。
*   Line 9：有可能这一步将网络层次上升几层。
*   Line 13：如果改变了$\delta (u)$，则优先队列会改变，如果没有改变$\delta (u)$仅仅改变了$l(u)$和$gap(u)$，则优先队列不变。
*   如果我们将$u \in V{'_l}$，$v \in {B_l}$的边$(u,v)$的层次下降1，约束1就会自动包括约束2。

## 算法优化

### 重新排列顶点

为了提高算法效率，我们可以根据顶点所在core的层次重新排列顶点，这样在高层次的core中搜索的效率会大大提升。

### 预计算最高层网络

从Highway Hierarchies的构造中，我们能看的出查询的最短路大部分都会经过最高层网络，所以若我们预计算出最高层网络的每一条最短路，形成一个距离表，那么将会大大的提高算法的效率。

由于距离表的存在，我们不需要再最高层网络中搜索；当我们到达一个属于$V{'_L}$的点$u$，我们将它加入集合$\mathop I\limits^ \to $或$\mathop I\limits^ \leftarrow $中，而且我们也不松弛指向第$L$层的边。当所有$L$层的入口都搜索过之后，我们考虑$\mathop I\limits^ \to $和$\mathop I\limits^ \leftarrow $能形成的所有边$(u,v) = \mathop I\limits^ \to \times \mathop I\limits^ \leftarrow $，那么起点到终点的最短距离即为$\min (\mathop \delta \limits^ \to (u) + {d_L}(u,v) + \mathop \delta \limits^ \leftarrow (v),d')$（PS：$d'$是为了防止起点与终点有不经过$L$层的最短路）。

为了将算法进行改进，我们先对各点的属性进行一定的修改：$r_l^ \leftrightarrow (u) = {\infty _1}$如果$u \notin V{'_l}$；$r_L^ \leftrightarrow (u) = {\infty _2}$如果$u \in V{'_L}$，其中${\infty _1}$和${\infty _2}$都是一个很大的数且${\infty _1} \ne {\infty _2}$。然后加入两行代码并修改一行代码即可：

*   在第7行和8行间加入：if $gap' \ne {\infty _1} \wedge l(u) = L$ then {$\mathop I\limits^ \leftrightarrow = \mathop I\limits^ \leftrightarrow \cup \{ u\} $；continue；}
*   在第11行和12行间加入：if $gap \ne {\infty _1} \wedge l = L \wedge l &gt; l(u)$ then {$\mathop I\limits^ \leftrightarrow = \mathop I\limits^ \leftrightarrow \cup \{ u\} $；continue；}
*   修改第16行：return $\min (\{ d'\} \cup \{ \mathop \delta \limits^ \to (u) + {d_L}(u,v) + \mathop \delta \limits^ \leftarrow (v)|u \in \mathop I\limits^ \to ,v \in \mathop I\limits^ \leftarrow \} )$；

### 算法的终止条件

在双向Dijkstra算法中，当算法的正向搜索和反向搜索相交时，我们就终止算法，所得的路径就是最短路径！而在上述的双向Highway Hierarchies搜索中，这样的结论并不成立。下图就是一个例子：

[![Query 4](http://www.lucienevans.com/wp-content/uploads/2014/10/Query-4.png)](http://7xjv88.com1.z0.glb.clouddn.com/1435115280) 图 4.算法终止条件的一个例子

图4中上面的搜索路径是应用这样的一个策略：每次选择方向时选择队列中元素多的那个方向。这样是可以得到几乎对称的路径，但我们不能保证这是一条最短路径，其实图4下面的路径才是一条最短路径，由于图中每个点的邻居半径是不等的，我们在搜索时极容易出现图4下面这样的情况：当反向搜索到b点时，正向搜索卡住在c点，由于我们的算法不能从高层次降到低层次，所以正向搜索到c点后就不会再运行了，只有等待反向搜索搜索到c点时才能得到一条路径。那么我们在搜索到图4上面的路径时就终止算法显然是错误的。

然而，我们可以采取一个保守的策略：当我们找到一条从起点到终点的路径$P'$后，所有$\delta (u) \ge \omega (P')$的点$u$都不往下进行算法了。虽然这个策略比较保守，但是在使用最高层距离表进行优化后，对于随机的查询来说效率还是很高的。

## 最短路径

图3中的算法只求出了两点之间的最短距离，要想求得两点之间的最短路径，只需在图3中的算法稍加修改，将每个点的父节点都存储起来，形成一颗搜索树即可。但是我们要想得到原图中的最短路径还有两个问题需要解决：

*   怎么将最高层网络中正向反向的路径连起来？（在优化了最高层网络距离表的情况下）
*   怎么将最短路中的捷径展开成原图中的路径？
对于第一个问题我们可以采用下述简单的算法：

1.  初始化$u$点为正向的入口，$v$点为反向的入口。
2.  遍历最高层网络距离表，对于每一条边$(u,\omega )$，如果$\omega = v$，则已经找到一条从$u$到$v$的最短路径，算法终止；如果${d_L}(u,\omega ) + {d_L}(\omega ,v) = {d_L}(u,v)$，则$u = \omega $，继续2。
第二个问题可以直接做一次最短路算法，对于一条捷径$(u,v) \in {S_l}$，我们直接在${G_l}$上搜索$(u,v)$的最短路，注意$(u,v)$在${G_l}$上的最短路可能包含低层次网络中的捷径，所以这个算法应该是递归的。

第二个问题还可以在每一条捷径中加入一定的信息，方便捷径的展开，这是一个以空间换取时间的例子。我们在每一条捷径中存储它经过的每一跳索引（<span style="color: #231f20;">_hop indices_</span>），例如捷径经过边$(u,v)$，我们只需记录$(u,v)$是第几条以$u$为起点的边即可，当然这里面可能包含低层网络的捷径，所以最后的展开算法仍然是递归的！因为图中平均每点的度都不会很大，所以我们只需要用一个很小的空间就可以给每条捷径记录上述的信息。

因为最高层网络中的捷径很多时候都会被用到，所以我们也可以将最高层网络中所有捷径的非递归信息都记录下来，最后展开最高层捷径时只需加以替换即可。

## 禁止转向

现实中的公路还有一些禁止转向的路段，比如，一个U字型的转弯被禁止：

[![U字转弯](http://www.lucienevans.com/wp-content/uploads/2014/10/捕获1.png)](http://7xjv88.com1.z0.glb.clouddn.com/1435115281)

&nbsp;

一般对于这种情况有两种解决方法：

1.  修改寻路算法，将禁止转向的几个路段存储起来，当寻路的时候判断寻找的路是否可行，具体可参考：<span style="color: #000000;">[MODELLING TURNING RESTRICTIONS IN TRAFFIC NETWORK FOR VEHICLE NAVIGATION SYSTEM](http://www.isprs.org/proceedings/xxxiv/part4/pdfpapers/410.pdf)。

2.  修改原图，引入人造节点和人造路段，如下图所示：

[![turnning restriction](http://www.lucienevans.com/wp-content/uploads/2014/10/turning-restriction.png)](http://7xjv88.com1.z0.glb.clouddn.com/1435115282) 图 5.给一个有转向限制的十字路口添加人造节点和人造路段

这样虽然会产生很多节点和路段，但是不用修改寻路算法。
在CH算法中，我们选用上述第2种方法处理路段的转向限制。因为一般添加的人造节点的度都会比较小，所以在构层次图的时候，会很早地就把他们省略，所以对于上层网络构图没有太大的影响，也就是说我们把方法2带来的内存开销大等坏处控制在低层次的网络中。
