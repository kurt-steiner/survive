#set document(title: "参数估计")
#set text(
  font: (
    (name: "JetBrains Mono", covers: "latin-in-cjk"),
    "Noto Sans CJK SC",
  ),
  size: 10pt,
)

#set page(margin: 1cm, height: auto)
#set enum(
  indent: 1.8em,      // 整体缩进
  body-indent: 0.6em, // 编号与文字间距
)

#set heading(numbering: "1.")


= 引例: 点估计

假设我们在相亲，女方需要暗搓搓知道我们的薪资水平，于是，她打听到

+ 我们从事于 后端开发
+ 职位是 高级工程师
+ 工作经验5年
+ 开的是一辆特斯拉Model3

女方开始进行 #highlight[点估计]:\
我闺蜜的老公也是同样的条件，年薪大概80万。我这相亲对象，估计也是这个数\
于是得出结论：年薪80万

实施上，这个80万不准确，我们实际的情况是100多万，多出来的20万是我们拍写真得来\
这个关乎自身清白，不能说出去

#line(stroke: green + 2pt, length: 100%)

如果女方手里有全国类似男人的薪资水平概率分布(总体的概率分布)，有

#align(center)[

#table(
  columns: 5,
  align: center,
  [$X$/万],[70],[80],[90],[100],
  [$P$],[$theta^2$],[$2theta (1 - theta)$],[$theta^2$],[$1-2theta$]
)
]

现在女方查了下本地类似男人的薪资水平(样本)，有 100,80,100,70,100,90,100\
现在问题变为了，如何通过这些样本推测我们的薪资水平

== 矩估计/砖家方案/术语高大上，但没什么卵用

砖家提出了一种"高大上"的方案 —— #underline(stroke: red + 2pt)[矩估计]\
什么是矩？就是*平均*的距离(average of distance)，距离有两种，一种是对原点的(对0)，一种是对中心的(对均值)

#grid(
  columns: (5fr, 5fr),
  column-gutter: 1cm,

  [
    #underline(stroke: blue + 2pt)[对于样本] ($X_1, X_2, dots, X_n$)，有k阶原点矩为
    $
      frac(1, n) sum_(i=1)^(n) X_i ^k
    $

    $overline(X)$ 为样本的均值，有k阶中心距为
    $
      frac(1, n) sum_(i=1)^(n) (X_i - overline(X))^k
    $

  ],
  [
    #underline(stroke: blue + 2pt)[对于总体]，有k阶原点矩为
    $
      E(X ^k)
    $

    有k阶中心距为
    $
      E(X^k - E(X^k))
    $
  ]
)

现在砖家给出观点——在 $n -> +infinity$ 时，样本的k阶原点矩/中心距 依概率 收敛于 总体的k阶原点矩/中心矩

#line(stroke: green + 2pt, length: 100%)

采用砖家的观点，我们采取1阶原点矩来进行估计

对于总体，其1阶原点矩(期望)为
$
  "Total"(E(X)) = 70 theta ^2 + 80 times 2 theta (1 - theta) + 90 theta^2 + 100 (1-2theta)
$

对于样本，其1阶原点矩为
$
  "Sample"(E(X)) = 1/7 times (100 + 80 + 100 + 70 + 100 +90 + 100)
$

现在使 
$
  "Sample"(E(X)) = "Total"(E(X))
$

能得到对概率分布的估计

== 最大似然估计/野路子/简单粗暴，却极其有效，但你不知道为什么可以这样

现在找的是外面的算命先生，算命先生看到 *样本值和对应的总体概率分布* 是

#align(center)[
#table(
  columns: 8,
  align: center,
  [$X$],[100],[80],[100],[70],[100],[90],[100],
  [$P$], [$1-2theta$],[$2theta (1 - theta)$],[$1-2theta$],[$theta^2$],[$1-2theta$],[$theta^2$],[$1-2theta$]
)
]

将样本概率相乘，得到一个函数$L(theta)$，有
$
  L(theta) = (1-2theta)^4 times 2theta(1-theta) times theta^4
$

现在我们需要调整 $theta$ 使 $L(theta)$ 取最大值即可，这摆明了就是#highlight[求导]\
出于简化计算考虑，取 $L(theta)$ 的对数，有
$
  ln(L(theta)) = 4ln(1-2theta) + ln(2theta(1-theta)) + 4ln(theta)
$
现在对其求导，使其为0 ，得到
$
  theta = 3/5 plus.minus sqrt(11) / 10
$

我们还有限制条件，对于每个情况来说，有

+ $theta^2 >= 0$
+ $2theta(1-theta) >=0$
+ $1 - 2theta >= 0$

整理，需要 $theta in [0, 0.5]$，从而有
$
  theta = 3/5 - sqrt(11) / 10
$

约为 $0.2683$

现在，我们将这个估计的值带入到总体的概率分布中，我们发现，刚好符合归一性，有
$
  theta^2 + 2theta(1-theta) + theta^2 + 1-2theta = 1
$

#line(stroke: green + 2pt, length: 100%)
正如标题所说的，这种方法跟偏方差不多，看着就是野路子，却特别管用，但你又不知道他为什么能解决问题

= 区间估计

沿用上面的例子，在相亲过程中，女方开始要求对方是200万年薪\
但据我们所知，在大厂当高级工程师，并有5年工作经验的薪资行情在60万到100万之间，特别牛逼的能到120万，差一点的在50万左右\
因此，我们有95%的把握确定我们的条件在 50万到110万 这个区间内

在这个例子中，置信水平是 $95%$，并且置信区间是 $[50, 110]$

并且，我们完全可以用 $P(hat(theta_1) <= theta <= hat(theta_2)) = 1 - alpha$ 来表示上述的估计情况，其中
+ $hat(theta_1)$ 是置信下限
+ $hat(theta_2)$ 是置信上限
+ $1 - alpha$ 是置信区间，对应的 $alpha$ 有个名词，叫显著性水平 (取名字的人是真该死啊)

借用正态分布的常用，普遍性，经过处理后，我们发现某个变量$X$是服从与某个正态分布的，其中期望和方差未知，现在我们任务是如何通过样本 #highlight[估计期望和方差]

== 估计期望

好在正态分布的图像是对称的，处于方便讨论的目的，我们假定 $hat(theta_1)$ 和 $hat(theta_2)$ 也是对称的，在图像上，有

#grid(
  columns: (5fr, 5fr),
  column-gutter: 0.5cm,

  [

  ],

  [
    
  ]
)

== 估计方差

= 补充：连续型分布的最大似然估计