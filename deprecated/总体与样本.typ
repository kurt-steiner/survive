#set document(title: "总体与样本")
#set text(
  font: (
    (name: "JetBrains Mono", covers: "latin-in-cjk"),
    "Noto Sans CJK SC",
  ),
  size: 10pt,
)

#set page(margin: 1cm, paper: "a4")
#set enum(
  indent: 1.8em,      // 整体缩进
  body-indent: 0.6em, // 编号与文字间距
)

#set heading(numbering: "1.")

= 三大抽样分布

考虑到教材上写的一坨屎，我先把这部分写出来\
一句话概括，这就是一个 #text(fill: red)[特征构造工程]

不过在探讨前我们需要限制条件——随机变量$X_1, X_2, dots, X_n$之间独立，同分布，且服从于正态分布$N(0, 1)$


== 卡方分布

对于卡方分布，我们用代码来描述一遍，现在有

+ 分布类型 `std_normal::Distribution`
+ 函数 `rand(distribution::Distribution, count::Int)::Float` ，表示从一个分布中，随机提取 `count` 个样本
+ 函数 `square(x::Number)::Number` ，表示对一个数字求平方

那么卡方分布 $chi^2(n)$ 可以描述成

```julia
function chi_2(n::Int)::Int
  array = rand(std_normal, n)
  array_squared = map(square, array)

  reduce(+, array_squared)
end
```

可以看到，这就是一个求平方和的过程，返回结果是个数字，#highlight[那又为什么叫作分布呢?]

这是因为，调用 `chi_2(n)` 的结果不是唯一的，因为每次从分布中拿取`n` 个样本不是都一样的\
如果我们固定 `n` 的值，并用图像画出卡方分布，那么

+ axis(x) 应该是 `x = chi_2(n)` 所有可能的取值
+ axis(y) 应该是 `x = chi_2(n)` 时的概率，即 $P(x = chi^2(n))$

既然可以画出分布，那我们记新的特征为 `Y = chi_2(n)`，有 $Y ~ chi^2(n)$

== t分布/联合分布

t 分布是一个联合了两个 #underline(stroke: blue + 2pt)[独立，不同分布] 的随机变量的分布，其中\

+ 随机变量 $X ~ N(0, 1)$
+ 随机变量 $Y ~ chi^2(n)$

先设 t分布的概率密度为 $f(x, y)$

#align(center)[
#table(
  columns: 4,
  align: center + horizon,

  table.header[$X \\ Y$][$Y_1$][$Y_2$][$Y_3$],

  [$X_1$],[$f(X_1, Y_1)$],[$f(X_1, Y_2)$],[$f(X_1, Y_3)$],
  [$X_2$],[$f(X_2, Y_1)$],[$f(X_2, Y_2)$],[$f(X_2, Y_3)$],
  [$X_3$],[$f(X_3, Y_1)$],[$f(X_3, Y_2)$],[$f(X_3, Y_3)$],
)
]

好在 $X, Y$ 是各自独立的，因此，我们也可以设概率密度为 $f(t)$，其中 $t = frac(X, sqrt(Y / n))$\
并给出结论 —— 在 $n -> +infinity$ 时，有 
$
f(t) = frac(1, sqrt(2 pi)) e^(-frac(t^2, 2))
$

刚好和标准正态分布的概率密度一样，也就是说， #underline(stroke: red + 2pt, extent: 2pt)[样本足够多时，$t(n)$分布近似于标准正态分布]

(这个东西就是一个联合分布)

== F分布/联合分布

现在有随机变量 $X ~ chi^2(m), Y ~ chi^2(n)$，我们构造随机变量 $F$，有
$
F = frac(X "/" m, Y "/" m) \
$

(这也完全可以看作一个联合分布)

= 样本的统计量

== 样本均值

我们从总体取出 $n$ 个样本，有 $X_1, X_2, dots, X_n$，那么
$
  overline(X) = frac(1, n) sum_(i=1)^(n) X_i
$

为样本均值

根据大数定律，有 $E(overline(X)) = E(X) = mu$，根据中心极限定理，有 $D(overline(X)) = sigma^2 / n$

== 样本方差
我们从总体取出 $n$ 个样本，有统计量 $S^2$，并且
$
 S^2 = frac(1, n-1) sum_(i=1)^(n) (X_i - overline(X))^2
$ 

我们称 $S^2$ 为样本方差

我们注意到，一般我们取 $n$ 个样本时的方差是
$
  frac(1, n) sum_(i=1)^(n) (X_i - E(X))^2
$

怎么到这里变成 $n - 1$ 了？

其实这个 $1/(n-1)$ 是个修正项，我们的目的是从 样本中推导出总体的方差，既然是样本，那肯定与总体是有一定偏差的\
既然有偏差，那我们就引入修正项，在教材里，这个修正项是 $1/(n-1)$，在其他的理论中，也可以使用其他修正项
#line(stroke: blue + 2pt, length: 100%)
同时我们也可以采纳另一种解释——擦屁股理论\
假设我现在要用 $n$ 张纸擦屁股，其中最后一擦时，如果发现没有痕迹了，我们才能确定是擦干净了，\
但在第 $n-1$ 张擦拭时，就已经擦干净了，但我们还要再擦一次确认一下，所以总的有效数量是 $n-1$
#line(stroke: blue + 2pt, length: 100%)
现在我们给出样本方差的期望为 $E(S^2) = D(X) = sigma^2$

== 样本的K阶原点矩

取 n 个样本，有统计量
$
  A_k = frac(1, n) sum_(i=1)^(n) X_i ^k
$

我们称之为 样本的K阶原点矩

== 样本的K阶中心矩

取 n 个样本，有统计量
$
  B_k = frac(1, n) sum_(i=1)^(n) (X_i - overline(X)) ^k
$

我们称之为 样本的K阶中心矩，其中样本均值就是那个中心