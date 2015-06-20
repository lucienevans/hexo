title: Dijsktra算法复杂度
tags:
  - 算法效率
id: 76
categories:
  - 算法
date: 2014-08-19 11:01:36
---

Dijsktra算法有不少变种，它们的时间复杂度都不一样，最近研究Router Planing in Road Network，里面对于Dijsktra时间复杂度分析的很好：

Initially, s is inserted into the priority queue with the tentative distance 0.Thus, s is reached, all other nodes are unreached. While the priority queueis not empty, the node u with the smallest tentative distance is removed(deleteMin) and added to the shortest-path tree, i.e., u becomes settled. Furthermore, u’s outgoing edges are relaxed:

*   if an edge (u, v) leads to an unreached node v, v is added to the priority queue (insert); now, v is reached;
*   if an edge (u, v) leads to a queued node v, v’s key in the priority queue is updated (decreaseKey) provided that the length of the path from s via u to v is less than v’s old key;
*   if an edge (u, v) leads to a settled node v, it is ignored
描述的就是Dijsktra算法的过程，可以看出，Dijsktra算法共需要n次insert，n次deleteMin，最多m次decreaseKey，那么时间复杂度就很好求了。

1.  用邻接矩阵或者邻接表储存，不使用优先队列，则每次insert、deleteMin都需要O(n)的时间复杂度，每次decreaseKey需要O(1)的时间复杂度，所以总共的时间复杂度是O(n^2+m)。一般来说n^2&gt;m，所以近似为O(n^2)。
2.  使用大顶堆优先队列，则每次insert、deleteMin和decreaseKey都需要需要O(log(n))的时间复杂度，所以总的时间复杂度是O((n+m)log(n))。
3.  使用Fibonacci优先队列，则每次insert、deleteMin都需要O(log(n))的时间复杂度，decreaseKey需要O(1)的时间复杂度，所以总的时间复杂度是O(m+nlog(n))。
