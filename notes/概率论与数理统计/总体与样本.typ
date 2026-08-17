#set document(title: "总体与样本")
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

= 三大抽样分布

== 卡方分布

从总体服从于$N(0, 1)$的序列中，提取$n$个样本，有变量$chi^2$
$
  chi^2 = X_1^2 + X_2^2 + dots + X_n^2 ~ chi^2(n)
$

如果我们用代码来描述卡方分布，有
```julia
function chi_2(std_normal::Distribution, n::Int)::Float64
  samples = rand(std_normal, n)
  squares = map(x -> x * x, samples)
  reduce(+, squares)
end
```

但这个函数不是只返回一个数字吗？为什么说他是个分布呢？\
问题在于 `rand` 函数，我们调用 `chi_2` 函数，每次调用的结果都不一样\
如果我们用图像画出卡方分布，有
+ axis(x) 表示 $chi_2$ 函数可能返回的所有数字
+ axis(y) 表示 $chi_2$ 函数返回对应数字 的概率

#grid(
  columns: (3fr, 7fr),
  column-gutter: 0.5cm,
  [
    #image("/images/image-10.png")
  ],

  [
    当$n=1$时，有
    $
    chi^2 = X^2 ~ chi^2(1)
    $
    当$n=2$时，有
    $
    chi^2 = X_1^2 + X_2^2 ~ chi^2(2)
    $
  ]
)

*FAQ*

为什么卡方分布是由 标准正态分布而来的？\
这可能也是为了方便运算吧，而且我们也能把一般的正态分布$N(mu, sigma^2)$转为标准正态分布$N(0, 1)$\
从而通过计算得到 卡方分布

#grid(
  columns: (5fr, 5fr),
  column-gutter: 1cm,
  [
    == T 分布

    根据定义，有
    $
      X ~ N(0, 1) \
      Y ~ chi^2(n)
    $
    从而有
    $
      T = X / sqrt(Y / n) ~ t(n)
    $

    并且在 $n -> +infinity$
    $
    t(n) -> N(0, 1)
    $

  ],

  [
    == F 分布

    现在有随机变量 $X ~ chi^2(m), Y ~ chi^2(n)$，我们构造随机变量 $F$，有
    $
    F = frac(X "/" m, Y "/" m) ~ F(m, n)
    $
  ]
)



= 正态总体的抽样分布

接下来我们要推导 正态总体的抽样分布中的 一些结论\
对于正态分布$N(mu, sigma^2)$，我们已经知道样本的均值序列 $overline(X) ~ N(mu, sigma^2 / n)$

== 关于卡方分布的结论

我们已经知道，卡方分布是 从总体(服从于标准正态分布$N(0, 1)$) 提取出$n$个样本后，构造变量$chi^2$得出的，有
$
  chi^2 = X_1^2 + X_2^2 + dots + X_n^2 ~chi(n)
$



#grid(
  columns: (5fr, 5fr),
  column-gutter: 1cm,
  [
    === 结论一/已知总体的期望

    现在，变量$X$来自于总体服从于$N(mu, sigma^2)$的正态分布，也就是 $X ~ N(mu, sigma^2)$\
    标准化后，有变量$Y$
    $
      Y_i = frac(X_i - mu, sigma) ~ N(0, 1)
    $

    那么，同样的，有
    $
      Y_1^2 + Y_2^2 + dots + Y_n^2 ~ chi^2(n)
    $

    也就是
    $
      sum_(i=1)^(n) (frac(X_i - mu, sigma))^2 = frac(1, sigma^2) sum_(i=1)^(n)(X_i - mu)^2 ~ chi^2(n)
    $

  ],

  [
    === 结论二/不知总体的期望/借助样本期望

    根据大数定律，均值序列的期望依概率收敛于总体的期望，即
    $
      lim_(n -> +infinity) overline(X) ->^P mu
    $

    对于样本来说，依然有
    $
      X("sample") ~ N(mu, sigma^2) ~ N(overline(X), sigma^2)
    $
    
    经过标准化后，得到
    $
      Y_i = frac(X_i - overline(X), sigma) ~ N(0, 1)
    $

    那么
    $
      sum_(i=1)^(n) (frac(X_i - overline(X), sigma))^2 = frac(1, sigma^2) sum_(i=1)^n (X_i - overline(X))^2 \
      = frac(1, sigma^2) (n - 1) S^2 ~ chi^2(n - 1)
    $
  ]
)

为什么在第二个结论中自由度是 $n-1$，请看 @自由度


== 关于t分布的结论

#grid(
  columns: (4fr, 6fr),
  column-gutter: 1cm,

  [
    我们已经知道，t分布是
    $
      X ~ N(0, 1)\
      Y ~ chi^2(n)\
      T = frac(X, sqrt(Y "/" n)) ~ t(n)
    $

  ],
  [
    对于均值序列 $overline(X)$，我们已经推导过，有
    $
      overline(X) ~ N(mu, sigma^2 / n)
    $

    经过标准化后，有
    $
      X' = frac(overline(X) - mu, sigma "/" sqrt(n)) ~ N(0, 1)
    $

    在上面的推导中，已经有
    $
    Y' = frac(1, sigma^2) (n-1) S^2 ~ chi^2(n-1)
    $
  ]
)

那么，现在我们构造变量$T$
$
T = frac(X', sqrt(Y "/" (n -1))) ~ t(n - 1)
$

展开后，有
$
  frac(overline(X) - mu, sigma "/" sqrt(n)) "/" frac(S, sigma) = frac(overline(X) - mu, S "/" sqrt(n)) ~ t(n - 1)
$
#line(length: 100%)

等等，这个形式怎么这么熟悉？对于均值序列有 $overline(X) ~ N(mu, sigma^2 "/" n)$，对其标准化后，有
$
  frac(overline(X) - mu, sigma "/" sqrt(n)) ~ N(0, 1)
$

看来这个t分布可以看作残缺的标准正态分布

= 补充: 样本的统计量

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

#grid(
  columns: (5fr, 5fr),
  column-gutter: 1cm,
  [
    其实这个 $1/(n-1)$ 是个修正项，我们的目的是从 样本中推导出总体的方差，既然是样本，那肯定与总体是有一定偏差的\
    既然有偏差，那我们就引入修正项，在教材里，这个修正项是 $1/(n-1)$，在其他的理论中，也可以使用其他修正项

  ],

  [
    其实我们也可以采纳另一种解释——擦屁股理论\
    假设我现在要用 $n$ 张纸擦屁股，其中最后一擦时，如果发现没有痕迹了，我们才能确定是擦干净了，\
    但在第 $n-1$ 张擦拭时，就已经擦干净了，但我们还要再擦一次确认一下，所以总的有效数量是 $n-1$
  ]
)

#line(length: 100%)
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

= 补充: 什么是自由度 <自由度>

在上述的卡方分布中，我们有 $chi^2(n)$ 表示自由度为$n$的卡方分布，也就是$n$个样本形成的分布

我们也可以解释样本方差为什么要除以$n-1$，对于样本，其中心距为
$
  sum_(i=1)^(n) (X_i - overline(X))^2 
$

其中均值$overline(X)$是根据$n$样本进行计算的，最终有效样本数是$n-1$