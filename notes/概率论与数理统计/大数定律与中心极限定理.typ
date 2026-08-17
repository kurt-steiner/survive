#set document(title: "大数定律与中心极限定理")
#set text(
  font: (
    (name: "JetBrains Mono", covers: "latin-in-cjk"),
    "Noto Sans CJK SC",
  ),
  size: 12pt,
)

#set page(margin: 1cm, paper: "a4", height: auto)
#set heading(numbering: "1.")
#outline()
#pagebreak()

= 吐槽
写这些教材的人是真该死啊，写的跟天书一样，压根就不想让人能看懂，应该拉到国道上，拦下一辆半挂，然后把他阿鲁巴 底大杠

= 大数定律

大数定律 说的东西只有一个
$
  lim_(n -> +infinity) overline(X) ->^P mu
$

== 切比雪夫大数定律/独立，不同分布

在一组数据 $"xs"$ 中，有

#align(center)[
#table(
  columns: 3,
  align: center + horizon,
  table.header[数据][所属分布][分布的理论期望],

  [$x s(1)$],[平均分布],[$mu s(1)$],
  [$x s(2)$],[指数分布],[$mu s(2)$],
  [$x s(3)$],[正态分布],[$mu s(3)$]
)
]

并且，这些数据的分布

+ 方差存在
+ 期望存在

那么有
$
  frac(1, n) sum_(i=1)^(+infinity) x s(i) -> ^P frac(1, n) sum_(i=1)^(+infinity) mu s(i)
$

即 #highlight[数据的均值] 依概率收敛于 #highlight[其分布的理论期望的均值]

== 切比雪夫大数定律/独立同分布 <切比雪夫大数定律2>

相似的，在一组数据中有

#align(center)[
#table(
  columns: 3,
  align: center + horizon,
  table.header[数据][所属分布][分布的理论期望],

  [$x s(1)$],[分布 D],[$mu$],
  [$x s(2)$],[分布 D],[$mu$],
  [$x s(3)$],[分布 D],[$mu$]
)
]

对于这个分布，同样有

+ 方差存在
+ 期望存在

上面的收敛变为了
$
  frac(1, n) sum_(i=1)^(+infinity) x s(i) -> ^P mu
$

== 辛钦大数定律/独立同分布

在上面的 @切比雪夫大数定律2 中，需要分布的 期望和方差 存在\
而辛钦他证明了，只需要知道分布的 期望存在，同样能推导出

$
  frac(1, n) sum_(i=1)^(+infinity) x s(i) -> ^P mu
$

= 中心极限定理

中心极限定理，说人话就一件事，对于均值序列 $overline(X)$
$
overline(X) ~ N(mu, sigma^2 "/" n)  
$

而在教材上描述了两种中心极限定理

== 列维-林德伯格/构造均值序列

#grid(
  columns: (5fr, 5fr),
  column-gutter: 1cm,

  [
    #image("/images/大数定律与中心极限定理.drawio.png")
  ],
  [
    从一个分布(期望为 $mu$，方差为 $mu^2$) 取出 $n$ 个数据

    ```ada
    XS: array(1..n) of Integer
    ```

    并构造均值
    ```ada
    Y := sum(XS) / n
    ```

    重复多次，构造出关于 均值的序列 `YS`，那么这个均值序列依概率趋向于 正态分布，其期望为 $mu$，方差为 $frac(sigma^2, n)$，即
    $
      Y ~ N(mu, frac(sigma^2, n))
    $

    将正态分布标准化，有
    $
      frac(Y - mu, sqrt(frac(sigma^2, n))) -> ^P phi(0, 1)
    $
  ]
)



=== 推导

对于均值 $Y$，有

$
  Y = frac(1, n) times sum_(i=1)^(+infinity) "XS"(i)
$
根据大数定律，有 $Y -> ^P mu$

我们知道，如果有两组数据 服从于同样的分布时，并且各自独立的话

```ada
XS_1 : array(1..n) of Integer;
XS_2 : array(1..n) of Integer;
```

如果将两组数据相加，有

```ada
declare
    XS_Result : array(1..n) of Integer;
begin
    for index in 1..n loop
        XS_Result(index) := XS_1(index) + XS_2(index)
    end loop;
end;
```

对于 `XS_Result`的方差，有
#align(center)[
#box(stroke: green + 2pt, inset: 2em)[
  ```ada
  D(XS_Result) = D(XS_1) + D(XS_2)
  ```
]
]

#grid(
  columns: (5fr, 5fr),
  column-gutter: 0.5cm,

  [
    那么，对于均值序列 `YS`，有
    $
      "YS" = frac(1, n) times mat(
        "XS"(1) + "XS"(2) + dots + "XS"(n);
        "XS"(1) + "XS"(2) + dots + "XS"(n);
        "XS"(1) + "XS"(2) + dots + "XS"(n);
        dots;
        "XS"(1) + "XS"(2) + dots + "XS"(n);
      )
    $

  ],

  [
    #image("/images/大数定律与中心极限定理-第 2 页.drawio.png")
  ]
)





再次将每个 $"XS"(1)$ 构造成一个序列，其方差依然是 $sigma^2$，依次类推，可以得出\

#align(center)[
#box(stroke: green + 2pt, inset: 2em)[
  `D(array of XS(i)) =` $sigma^2$
]
]

而 $"YS"$ 可以看作
$
  "YS" = frac(1, n) times mat("XS"(1); "XS"(1); dots; "XS"(1);) + frac(1, n) times  mat("XS"(2); "XS"(2); dots; "XS"(2);) + frac(1, n) times mat("XS"(3); "XS"(3); dots; "XS"(3);) + dots + frac(1, n) times mat("XS"(n); "XS"(n); dots; "XS"(n);)
$

那么 $D("YS") = frac(1, n^2) times n times sigma^2 = frac(sigma^2, n)$

== 棣弗莫-拉普拉斯/被忽略的二项分布

我们忽略了一件事，我们完全可以从 二项分布$B(n, p)$推导出正态分布，其期望和方差是$n p, n p (1 - p)$\
那么对于 $X ~ B(n, p)$ 来说，有
$
  X ~ N(n p, n p (1 - p))
$

将正态分布标准化，有
$
  frac(X - n p, sqrt(n p ( 1- p))) -> ^P phi(0, 1)
$

= 补充：切比雪夫不等式

#align(center)[
  #image("../../images/切比雪夫不等式.png", height: 30%)
]

对于某个分布，有期望和方差 $mu, sigma^2$；描述其期望，有
$
  E(X) = integral_(-infinity)^(+infinity) x f(x) dif x
$

在 $x >= a$ 时，有
$
  E(X) >= integral_(a)^(+infinity) x f(x) dif x
$

由于 $x >= a$，有
$
  integral_(a)^(+infinity) x f(x) dif x >= a integral_(a)^(+infinity) f(x) dif x
$

而右边刚好是
$
  a integral_(a)^(+infinity) f(x) dif x = a times P(X >= a)
$

整理，有
$
  E(X) >= a P(X >= a)
$

再次整理，得到
$
  P(X >= a) <= frac(E(X), a)
$

现在，设 $Y = (X - E(X))^2$，有
$
  P(Y >= a) = P((X - E(X)^2) >= a) <= frac(E((X - E(X))^2), a)
$

而 $E((X - E(X))^2) = D(X)$，有
$
  P(|X - E(X)| >= sqrt(a)) <= frac(D(X), a)
$

也可以记为
$
  P(|X - E(X)| >= a) <= frac(D(X), a^2)
$

这个不等式的意思是，在分布上取一点，得到与 $E(X)$ 的距离 大于 a 的概率
