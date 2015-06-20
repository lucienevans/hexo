title: Dijsktra+堆
tags:
  - 数据结构
  - 算法效率
id: 56
categories:
  - 算法
date: 2014-08-04 22:02:21
---

Dijkstra算法是求图中最短路的算法。最原始的Dijsktra算法，使用邻接表的时间复杂度是O(n^2)，使用邻接矩阵的时间复杂度是O(m+n^2)。若使用小顶堆表示优先队列，则可以将每次寻找最短点的时间复杂度降到O(log(n))，将decreaseKey复杂度降到log(n),即Dijsktra总体复杂度降为O((m+n)*log(n))。若采用更复杂的数据结构表示优先队列，会使得复杂度更低。具体复杂度计算
<!-- more -->

下面是Dijsktra+小顶堆的demo代码：
```
#include&lt;stdio.h&gt;
#include&lt;string.h&gt;
#include&lt;queue&gt;
#include&lt;vector&gt;

using namespace std;

const int MAXN=1000;
const int INF = 0x3f3f3f3f;
//优先队列所需结构体
struct Node {
	int val,d;
	Node(int a,int b){
		val=a; d=b;
	}
	bool operator &lt; (const Node&amp; a) const {
		if(d==a.d) return val&lt;a.val;
		else return d&gt;a.d;
	}
};
//邻接表
int g[MAXN][MAXN],n;
//各点距离,是否访问过该点
int dist[MAXN],visit[MAXN];

void Dijkstra(int s){
	int i;
	//初始s到各点距离为INT_MAX
	memset(dist,0x3f,sizeof(dist));
	memset(visit,0,sizeof(visit));
	dist[s]=0;
	//优先队列
	priority_queue&lt;Node&gt; q;
	q.push(Node(s,dist[s]));
	while(!q.empty()){
		Node temp=q.top();
		q.pop();
		for(i=1;i&lt;=n;i++){
			if(!visit[i] &amp;&amp; g[temp.val][i]+dist[temp.val]&lt;dist[i]){
				dist[i]=g[temp.val][i]+dist[temp.val];
				q.push(Node(i,dist[i]));
		                visit[i]=true;
			}
		}
	}
}

int main(){
	int a,b,d,m,i;
	while(scanf("%d %d",&amp;n,&amp;m) &amp;&amp; (n||m)){
		//初始化
		memset(g,0x3f,sizeof(g));
		while(m--){
			scanf("%d %d %d",&amp;a,&amp;b,&amp;d);
			g[a][b]=g[b][a]=d;
		}
		Dijkstra(1);
		for(i=1;i&lt;=n;i++)
			printf("1--&gt;%d:%d\n",i,dist[i]);
	}
	return 0;
}
```
