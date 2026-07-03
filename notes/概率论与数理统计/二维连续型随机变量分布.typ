#set document(title: "二维连续型随机变量分布")
#set text(
  font: (
    (name: "JetBrains Mono", covers: "latin-in-cjk"),
    "Noto Sans CJK SC",
  ),
  size: 12pt,
)
#set page(margin: 1cm)
#outline()
#pagebreak()
//#set page(paper: "a4")
#set heading(numbering: "1.")

= 分布函数法(通用方法)

我们有随机变量 $(X, Y)$ 的概率密度为$"f(x, y)"$，现在有 $Z = "g(x, y)"$，需要求 $Z$ 的概率密度函数\
对于$Z$ 的概率分布(累计)函数，有
$
  P_Z ("i(z)") = P(Z <= "i(z)") = P("g(x, y)" <= "i(z)")
$
如果用二重积分进行表达，有
$
  P_Z ("i(z)") = limits(integral.double)_("g(x, y)" <= "i(z)") "f(x, y)" dif x dif y
$

#line(length: 100%, stroke: blue + 1pt)

现在有 $(X, Y)$ 在矩形 #box(fill: yellow.transparentize(20%), outset: (y: .4em), $G = {(x, y) | x in (0, 2), y in (0, 1)}$) 上服从 #underline[均匀分布]，求 $Z = "XY"$ 的概率密度函数

既然是均匀分布，有
$
  f(x, y) = cases(
    1/2 ", " 0<=x <=2 "," 0 <= y <= 1,
    0 ", " "else"
  )
$

对 $Z="XY"$有概率分布(累计)函数
$
  P_Z ("i(z)") =P_Z (Z <= "i(z)") = P("XY" <= "i(z)") \
  = limits(integral.double)_("XY" <= "i(z)") 1/2 dif x dif y
$

算出对变量 $"i(z)"$ 的函数后，再对$"i(z)"$ 进行求导即可

#pagebreak()

= 卷积公式法(线性变换)

== 回顾: 边缘密度

假设有二维连续型随机变量 $(X, Y) ~ f(x, y)$，如果用表格去描述他的 联合概率密度，有

#align(center)[
#table(
  columns: 5,
  inset: 8pt,
  align: center + horizon,
  table.header[$X "\\" Y$][$y_1$][$y_2$][$y_3$][$y_4$],
  [$x_1$], [$f(x_1, y_1)$], [$f(x_1, y_2)$], [$f(x_1, y_3)$], [$f(x_1, y_4)$],
  [$x_2$], [$f(x_2, y_1)$], [$f(x_2, y_2)$], [$f(x_2, y_3)$], [$f(x_2, y_4)$],
  [$x_3$], [$f(x_3, y_1)$], [$f(x_3, y_2)$], [$f(x_3, y_3)$], [$f(x_4, y_4)$],
  [$x_4$], [$f(x_4, y_1)$], [$f(x_4, y_2)$], [$f(x_4, y_3)$], [$f(x_4, y_4)$],
)
]

虽然不太严谨，我们依然能得出
$
  f_X (x_1) = f(x_1, y_1) + f(x_1, y_2) + f(x_1, y_3) + f(x_1, y_4)
$

也就是说，有 #highlight[边缘密度]
$
  f_X (i(x)) = integral f(i(x), y) dif y \
  f_Y (i(y)) = integral f(x, i(y)) dif x
$
== 卷积公式

#align(center)[#image("../images/卷积公式_20260630_143505.png", height: 30%, alt: "image")]


在 $"xOy"$ 面上，有区域 $D$ 为矩形 $x in [0, 1], y in [0,1]$，二维连续型随机变量 $X, Y$ 的概率密度函数为

$
  f(x, y) = cases(
    & 2 - x - y & "   " & (x, y) in D &,
    & 0 & "   " & "else" &
  )
$

现在需要我们求出 $Z = X + Y$ 的概率密度函数

#line(length: 100%, stroke: blue + 1pt)

我们看到，上面的题目 让我们从 二个随机变量的联合概率密度 推导出 单个随机变量的概率密度，这不就是 #highlight[边缘密度] 吗？\
上面我们推断过，
$
  f_X (i(x)) = integral f(i(x), y) dif y \
$

求边缘密度的时候，对另一个变量积分就行了
#line(length: 100%, stroke: green + 1pt)
现在，我们的思路是，将 $f(x, y)$ 转为 $(x, z)$ 的函数，#box(stroke: blue + 1pt, inset: 3pt)[再对 $x$ 积分]，#underline[从而求得边缘密度]

我们先转换下$f(x, y)$，对于$f(x, y) = 2 - x - y$，由于$z = x + y$，可以表示为
$
  f(x, z) = 2 - z
$

此时
$
  & x in [0, 1] & \
  & y in [0, 1] &
$

由于 $z = x + y$，有
$
  z - x in [0, 1] \
  -x in [-z, 1 -z] \
  x in [z - 1, z]
$

现在 $x$ 的范围确定为
$
  &"lower:"& max(0, z - 1) \
  &"upper:"& min(1, z)
$

依然要进行分类讨论，\
当 $z in (0, 1)$ 时，有
$
  x in (0, z)
$

当 $z in (1, 2)$ 时，有
$
  x in (z - 1, 1)
$

在 $z in (0, 1)$ 时，边缘密度为
$
  f_Z (z) = integral_(0)^(z) (2-z) dif x = 2z - z^2
$

在 $z in (1, 2)$ 时，边缘密度为
$
  f_Z (z) = integral_(z-1)^(1) (2 - z) dif z = (2 - z)^2
$


#pagebreak()



= 最大最小分布

== 题目描述

#align(center)[
  #image("../images/卷积公式_20260630_143505.png", height: 30%, alt: "image")
]

在 $"xOy"$ 面上，有区域 $D$ 为矩形 $x in [0, 1], y in [0,1]$，二维连续型随机变量 $X, Y$ 的概率密度函数为

$
  f(x, y) = cases(
    &x + y& "   " (x, y) in D,
    &0& "   " "else"
  )
$

现在我们要求 $z = max{X, Y}$ 和 $z = min{X, Y}$ 的概率密度函数

== 解法

=== max
我们知道，对于概率分布(累积)函数来说，有
$
  P_Z ("i(z)") = P(Z <= "i(z)")
$

现在，对于 $Z = max{X, y}$，有
$
  P(max{X, Y} <= "i(z)")
$

在积分区域上，有
$
  x <= "i(z)" \
  y <= "i(z)"
$

积分区域画出来是个正方形
#align(center)[
  #image("../images/最大最小分布.png", height: 30%)
]


当 $"i(z)" in (0, 1)$  时，才有积分区域，即
$
  P_Z ("i(z)") = cases(
    &0& "   " "i(z)" <= 0,
    &F("i(z)")& "   " "i(z)" in (0, 1),
    &1& "   " "i(z)" in (1, +infinity)
  )
$

在 $"i(z)" in (0, 1)$ 上，有
$
P_Z ("i(z)")  = limits(integral.double)_(x in (0, "i(z)", \
y in (0, "i(z)"))) (x + y) dif x dif y
$

展开为累次积分，有
$
  &integral_(0)^("i(z)") dif x integral_(0)^("i(z)") (x + y) dif y& \
  = &z^3&
$

对其求导，获得概率密度函数
$
  f_Z ("i(z)") = 3z^2 "  " z in (0, 1)
$


=== min

同样的，有
$
  P(min{X, Y} <= "i(z)")
$

那积分区域还是
$
  x <= "i(z)" \
  y <= "i(z)"
$

这感觉有点不对，和 $z = max{X, Y}$ 的积分区域一模一样  \
我们只能换一种角度去求表示概率，有
$
  P_Z ("i(z)") = P(Z <= "i(z)") \
  P(Z <= "i(z)") = 1 - P(Z > "i(z)")
$

那么有
$
  P(min{X, Y} <= "i(z)") = 1 - P(min{X, Y} > "i(z)")
$

现在，积分区域是

$
  1 > x > "i(z)" \
  1 > y > "i(z)"
$

在图像中画出来是
#align(center)[
  #image("../images/最大最小积分-2.png", height: 30%)
]
现在，概率可以表示为
$
  P(min(X, Y) <= "i(z)") = 1 - P(min(X, Y) > "i(z)")
$

右边的积分为
$
  integral_("i(z)")^(1) dif x integral_("i(z)")^(1) (x + y) dif y 
  = 1 - z - z^2 + z^3
$

最终求得
$
  P(min(X, Y) <= "i(z)") = z + z^2 - z^3
$

求导，得到
$
  f_Z (z) = 1 + 2z - 3z^2
$

= 补充: 这三种方法在什么时候用

我们发现卷积公式在 $Z = "XY"$ 上是求不出正确的 概率密度函数的，这是因为 卷积公式法 主要针对的是 线性变化，不能用到 $X times Y$ 或 最大最小分布 上