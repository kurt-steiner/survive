#set document(title: "参数估计与假设检验")
#set text(
  font: (
    (name: "JetBrains Mono", covers: "latin-in-cjk"),
    "Noto Sans CJK SC",
  ),
  size: 10pt,
)
#set page(margin: 1cm, paper: "a4", height: auto)
#set enum(
  indent: 1.8em,      // 整体缩进
  body-indent: 0.6em, // 编号与文字间距
)

#set heading(numbering: "1.")

#outline()
#pagebreak()

#image("/images/参数估计与假设检验.png")

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

(区间估计需要用到 正态总体的抽样分布，请看 #link("file://./总体与样本.typ")[总体与样本这一章节])

沿用上面的例子，在相亲过程中，女方开始要求对方是200万年薪\
但据我们所知，在大厂当高级工程师，并有5年工作经验的薪资行情在60万到100万之间，特别牛逼的能到120万，差一点的在50万左右\
因此，我们有$95%$的把握确定我们的条件在 50万到110万 这个区间内

在这个例子中，置信水平是 $95%$，并且置信区间是 $[50, 110]$

并且，我们完全可以用 $P(hat(theta)_1 <= theta <= hat(theta)_2) = 1 - alpha$ 来表示上述的估计情况，其中
+ $hat(theta)_1$ 是置信下限
+ $hat(theta)_2$ 是置信上限
+ $1 - alpha$ 是#underline[置信区间]，对应的 $alpha$ 有个名词，叫 #underline[显著性水平] (取名字的人是真该死啊)

借用正态分布的常用性和普遍性，经过处理后，我们发现总体的变量$X$是服从与某个正态分布的，有$X ~ N(mu, sigma^2)$，其中期望和方差可能未知\
从总体中提取样本，有样本均值序列中的变量 $overline(X) ~ N(mu, sigma^2/n)$

现在我们任务是 #underline(stroke: 2pt + blue)[如何通过样本 #highlight[估计总体的期望和方差]]

== 估计期望

好在正态分布的图像是对称的，处于方便讨论的目的，我们假定 $hat(theta_1)$ 和 $hat(theta_2)$ 也是对称的，在图像上，有

#grid(
  columns: (5fr, 5fr),
  column-gutter: 0.5cm,

  [
    #image("/images/参数估计.png")
  ],

  [
    根据 上$alpha$分位点的定义，我们有
    $
      hat(theta)_2 = u(alpha / 2)
    $

    再有对称，得到
    $
      hat(theta)_1 = -u(alpha / 2)
    $

    #underline(stroke: blue + 2pt)[借助标准正态分布，有]
    $
      P(-u(alpha / 2) <= overline(X) <= u(alpha / 2))  = 1-alpha
    $

    整理后
    $
      P(-u(alpha / 2) <= frac(overline(X) - mu, sigma "/" sqrt(n)) <= u(alpha / 2))  = 1-alpha
    $
  ]
)

现在再次整理，有
$
  P(overline(X) - frac(sigma, sqrt(n)) times u(alpha/2) <= mu <= overline(X) + frac(sigma, sqrt(n)) times u(alpha / 2)) = 1 - alpha
$

其中 $u(alpha/2)$是 #highlight[标准正态分布]的上$alpha/2$分位点，也可以表示为
$
  P(overline(X) - frac(sigma, sqrt(n)) times u(alpha/2, "StdNormal") <= mu <= overline(X) + frac(sigma, sqrt(n)) times u(alpha / 2, "StdNormal")) = 1 - alpha
$

#line(stroke: green + 2pt, length: 100%)

等等，上面的情况中，好像是需要总体的方差 $sigma^2$ 是已知的，如果 $sigma^2$ 未知呢？\
根据正态分布总体的抽样，有
$
  frac(overline(X) - mu, S "/" sqrt(n)) ~ t(n-1)
$

其中 $S$ 是样本的标准差，经过整理，有
$
  P(overline(X) - frac(S, sqrt(n)) times u(alpha/2, t(n-1)) <= mu <= overline(X) + frac(S, sqrt(n)) times u(alpha / 2, t(n-1))) = 1 - alpha
$

== 估计方差

与估计期望不同，估计期望时是借助的正态分布，而估计方差时，借助的是卡方分布，对于样本($n$)，有
$
frac(n-1, sigma^2) times S^2 ~ chi^2(n-1)
$

借助卡方分布的图像，有
#grid(
  columns: (5fr, 5fr),
  column-gutter: 0.5cm,
  [
    #image("/images/参数估计-第 2 页.png")
  ],

  [
    其中，卡方分布的图像明显是不对称的，我们这样做也是装糊涂，还好有错误率兜底\
    此时，根据上$alpha$分位点的定义，有
    $
      &hat(theta)_2& &= u(alpha / 2)& \
      &hat(theta)_1& &= u(1 - alpha / 2)&
    $

    现在估计方差，有
    $
      P(u(1-alpha/2) <= frac(n - 1, sigma^2) times S^2 <= u(alpha / 2)) = 1-alpha
    $

    整理后，得到
    $
      P(frac((n - 1) S^2, u(alpha/2)) <= sigma^2 <= frac((n-1) S^2, u(1 - alpha /2))) = 1-alpha
    $
  ]
)

其中 $u(alpha/2)$ 是 $chi^2(n-1)$ 的上$alpha/2$分位点，也就是
$
  P(frac((n - 1) S^2, u(alpha/2, chi^2(n-1))) <= sigma^2 <= frac((n-1) S^2, u(1 - alpha /2, chi^2(n-1)))) = 1-alpha
$

#line(stroke: green + 2pt, length: 100%)
我们发现，上面这种情况中，压根就没有用到总体的期望$mu$，也就是说，此时总体的期望是未知的\
那如果总体的期望是已知的呢？

对于样本，刚才我们用的是
$
  frac((n-1) S^2, sigma^2) ~ chi^2(n-1)
$

也就是
$
  frac(1, sigma^2)  times sum_(i=1)^(n) ("sample"(X_i) - overline(X))^2 ~ chi^2(n-1)
$

现在我们用另一个结论
$
  frac(1, sigma^2) times sum_(i=1)^(n) ("sample"(X_i) - mu)^2 ~ chi^2(n) 
$

再次进行推导，有
$
  P(frac(sum_(i=1)^(n) (X_i - mu)^2, u(alpha/2, chi^2(n))) <= sigma^2 <= frac(sum_(i=1)^(n) (X_i - mu)^2, u(1 - alpha /2, chi^2(n)))) = 1-alpha
$


这几个逼玩意是真难记啊，建议当场推导

= 假设检验

某次考试的学生成绩服从正态分布，从中随机抽取36位考生的成绩，算得平均成绩为66.5分，标准差为15分，问：\
在显著性水平0.05下，是否可以认为这次考试全体考生的平均成绩为70分？并给出检验过程

附表: t分布下分位点
$
P{t(n) <= t_p(n)} = p
$

#align(center)[
  #table(
    columns: 3,
    align: center + horizon,
    [$n "\\" P$ ],[0.95],[0.975],
    [35],[1.6896],[2.0301],
    [36],[1.6883],[2.0281]
  )
]

#line(length: 100%)

#grid(
  columns: (5fr, 5fr),
  column-gutter: 0.5cm,

  [
    我们给出假设$H_0$为 此次考试全体考试的平均成绩为70分，即$mu = 70$，现在有

  #align(center)[
    #table(
      columns: 3,
      align: center + horizon,
      [假设],[判断 $mu = 70$],[判断 $mu != 70$],
      [$mu = 70$],[$mu = 70$],[$mu != 70$],
      [$mu != 70$],[$mu = 70$],[$mu != 70$],
    )
  ]

  其中显著性水平(即错误率)体现在
  $
    P("判断" mu != 70 | "假设" mu = 70) = alpha
  $

  ],

  [
    我们在区间估计中，有置信区间为
    $
      P(hat(theta)_1 <= theta <= hat(theta)_2) = 1-alpha
    $

    当置信区间的上下限对称时，有
    $
      P(-u(alpha / 2) <= theta <= u(alpha / 2)) = 1-alpha
    $

    那么显著性水平$alpha$体现在
    $
      P(abs(theta) >= u(alpha / 2)) = alpha
    $
  ]
)


#line(length: 100%)


对于我们的假设，借助t分布，有
$
T = frac(overline(X) - mu, S "/" sqrt(n)) ~ t(n - 1)
$

如果$T$落在落在置信区间时，有
$
P(-u(t(n-1), alpha / 2) <= frac(overline(X) - mu, S "/" sqrt(n)) <= u(t(n-1), alpha / 2)) = 1 - alpha
$

即判断
$
  abs(frac(overline(X) - mu, S "/" sqrt(n))) <= u(t(n-1), alpha / 2)
$

其中，$mu = 70$是我们的假设，需要带入计算，并且，我们还需要将 *上$alpha$分位点* 和 *下$alpha$分位点相互转换*


= 补充：连续型分布的最大似然估计

以均匀分布为例，有概率分布在 $[0, a]$ 之间，其概率密度函数为
$
  f(x) = cases(1 "/" a " " x in [0, a], 0 " " "else")
$

从总体中提取样本，得到 $X_1, X_2, X_3, dots, X_n$，其最大似然函数为
$
  L(a) = frac(1, a^n)
$

使其最大，需要使 $a$ 最小

#import "@preview/cetz:0.5.2": canvas
#import "@preview/cetz-plot:0.1.4": plot

#align(center)[
#canvas({
  plot.plot(
    size: (8, 5),
    x-label: $X$,
    y-label: $P(X)$,
    y-max: 1,
    y-min: 0,
    x-max: 10,
    x-min: 0,
    x-tick-step: none,
    y-tick-step: 0.5,
    axis-style: "left",

    x-ticks: (
      (1, [$X_1$]),
      (2, [$X_2$]),
      (3, [$X_3$]),
      (4, [$X_4$]),

      (7, [$X_n$]),
      (8, [$<-$]),
      (9, [$<-$]),
      (10, [$a$])
    ),

    
    {
      // Main tanh curve
      plot.add(
        style: (stroke: blue + 1.5pt),
        domain: (0, 11),
        samples: 100,
        x => 2/3,
      )

      plot.add(
        style: (
          stroke: (paint: red, dash: "dashed")
        ),
        
        domain: (0, 1),
        samples: 2,
        y => (10, y)
      )

      plot.add(
        style: (
          stroke: (paint: red, dash: "dashed")
        ),
        
        domain: (0, 1),
        samples: 2,
        y => (9, y)
      )

      plot.add(
        style: (
          stroke: (paint: red, dash: "dashed")
        ),
        
        domain: (0, 1),
        samples: 2,
        y => (8, y)
      )

      plot.add(
        style: (
          stroke: (paint: red, dash: "dashed")
        ),
        
        domain: (0, 1),
        samples: 2,
        y => (7, y)
      )
    }
  )
})
]


将 $a$ 往左移动，最大只能移动到 $max("samples"(X_1, X_2, dots, X_n))$ 的位置，否则样本不合法，此时最大似然估计成立

= 补充: 上$alpha$分位点 和 下$alpha$分位点

当
$
  P(X >= u(alpha)) = alpha
$

我们称 $u(alpha)$ 为上$alpha$分位点

当
$
  P(X <= d(alpha)) = alpha
$

我们称 $d(alpha)$ 为下$alpha$分位点