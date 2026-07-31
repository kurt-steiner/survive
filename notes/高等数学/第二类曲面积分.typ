#set document(title: "第二类曲面积分")
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

#outline()
#pagebreak()

= 投影视角与代数视角

我们用向量去描述流量，有
$
  arrow(v) = (P, Q, R)
$

其中
+ P 表示在 axis(x) 方向上的流量函数，随$(x, y, z)$的变化而变化，有 $P(x, y, z)$
+ Q 表示在 axis(y) 方向上的流量函数，随$(x, y, z)$的变化而变化，有 $Q(x, y, z)$
+ R 表示在 axis(x) 方向上的流量函数，随$(x, y, z)$的变化而变化，有 $R(x, y, z)$



#grid(
  columns: (5fr, 5fr),
  column-gutter: 0.1cm,
  [
    == 投影视角

    对于曲面$sum$，将其投影到 xOy, xOz, yOz 面上有
    #image("/images/线面积分-第 3 页.drawio.png")
    
    那么，\
    在 xOy 面上的流量有
    $
      "Flux"("xOy") = limits(integral.double)_(sum ("xOy")) R dif x dif y
    $
    
    在 xOz 面上的流量有
    $
      "Flux"("xOz") = limits(integral.double)_(sum ("xOz")) Q dif x dif z
    $

    在 yOz 面上的流量有
    $
      "Flux"("yOz") = limits(integral.double)_(sum ("yOz")) P dif y dif z
    $

    总流量有
    $
      "Flux" = limits(integral.double)_(sum ("xOy")) R dif x dif y + limits(integral.double)_(sum ("xOz")) Q dif x dif z + limits(integral.double)_(sum ("yOz")) P dif y dif z
    $
    
  ],

  [
    == 代数视角

    对曲面$sum$中取面积微元$dif S$，流量 $arrow(v)$ 穿过$dif S$，有
    #image("/images/线面积分-第 4 页.drawio.png")

    其中 $arrow(n)$ 是 $dif S$ 的单位化法向量，那么有效的流量微元$dif F$是
    $
      dif F = arrow(v) dot arrow(n) dot dif S
    $

    我们设置
    + $alpha$ 是 $n$ 对 $x$ 轴的夹角
    + $beta$ 是 $n$ 对 $y$ 轴的夹角
    + $gamma$ 是 $n$ 对 $z$ 轴的夹角

    而 $arrow(n)$ 是单位化的向量，有
    $
      &arrow(n) = (cos alpha, cos beta, cos gamma)& \
      &cos^2 alpha + cos^2 beta + cos^2 gamma = 1&
    $

    #grid(
      columns: (5fr, 5fr),
      column-gutter: 0.5cm,

      [
        我们先画出一个面积微元
        #image("/images/线面积分-第 6 页.drawio.png")
      ],

      [
        紫色线条组成的平面与 xOy 面垂直，有
        #image("/images/线面积分-第 7 页.drawio.png")
        
      ]
    )

    由于法向量与 $z$ 轴的夹角是 $gamma$，那么
    $
      dif x dif y = dif S cos gamma
    $

    同样的，有
    $
      dif y dif z = dif S cos alpha\
      dif x dif z = dif S cos beta
    $

    那么 $arrow(n) = (cos alpha, cos beta, cos gamma)$，总流量可以表示为
    $
      "Flux" = limits(integral.double)_(sum) (P cos alpha + Q cos beta + R cos gamma) dif S
    $

  ]
)

== 合并

两个视角对比之下，有

#grid(
  columns: (5fr, 5fr),
  column-gutter: 0.5cm,

  [
    #highlight[*投影视角*]

    $
      "Flux"("yOz") = integral.double P dif y dif z\
      "Flux"("xOz") = integral.double Q dif x dif z\
      "Flux"("xOy") = integral.double R dif x dif y
    $

  ],

  [
    #highlight[*代数视角*]

    $
      "Flux"("yOz") = integral.double P cos alpha dif S\
      "Flux"("xOz") = integral.double Q cos beta dif S\
      "Flux"("xOy") = integral.double R cos gamma dif S
    $
  ]
)

那么
+ $dif y dif z = cos alpha dif S$
+ $dif x dif z = cos beta dif S$
+ $dif x dif y = cos gamma dif S$


然而，我们在 @补充 推导出，在曲面 $z = f(x, y)$ 中，在点 $(x, y, z)$ 处的法向量(未单位化)\
可能是
$
  arrow(n) = (frac(partial f, partial x), frac(partial f, partial y), -1)
$
也可能是
$
  arrow(n) = (-frac(partial f, partial x), -frac(partial f, partial y), 1)
$

而我们设 $dif S$ 的法向量 为 $(cos alpha, cos beta, cos gamma)$，数值肯定是有正有负，那么在 *代数视角* 下的各部分流量都是有正负的\
而投影视角与代数视角应该是等价的，我们只能说明上面的 #highlight[投影视角] 描述的是 #text(fill: red)[*数值部分*]，修正后的形式应该是

$
  "Flux"("yOz") = plus.minus integral.double P dif y dif z\
  "Flux"("xOz") = plus.minus integral.double Q dif x dif z\
  "Flux"("xOy") = plus.minus integral.double R dif x dif y
$

每个部分的正负由 #underline(stroke: blue + 2pt, extent: 2pt)[曲面方向] 对应的法向量 #underline(stroke: blue + 2pt, extent: 2pt)[各部分数值决定]

= 计算方法

对曲面积分不能直接来，得换着方法间接积分

== 转换到 对平面积分

如果我们要求曲面积分
$
  limits(integral.double)_(sum) x y z dif x dif y
$

其中 $sum$ 是球面 $x^2 + y^2 + z^2 = 1$ 外侧在 $x >= 0, y>=0$ 的部分

#line(stroke: blue + 2pt, length: 100%)

注意到积分的函数的 $z$ 是脱离于$x, y$，我们需要做的是将$z$转为$f(x, y)$的形式，这样才能进行 $dif x dif y$ 的积分

我们先画出这个曲面
#grid(
  columns: (3fr, 7fr),
  column-gutter: 1cm,

  [
    #image("/images/第二类曲面积分.png")
  ],

  [
    #highlight[可以看到此时 $z$ 有两种取值]，一是在 $z > 0 $ 时有 $z = sqrt(1 - x^2 - y^2)
    $，再是 $z < 0$ 时，有 $z = -sqrt(1 - x^2 - y^2)$

    #highlight[现在积分有两个部分]，在曲面 $sum_1$ 上有 $z >= 0$，在曲面 $sum_2$ 上有 $z <= 0$，于是

    $
      &"part(1)"& = &limits(integral.double)_(sum_1) x y sqrt(1 - x^2 - y^2) dif x dif y\
      &"part(2)"& = &limits(integral.double)_(sum_2) x y times (- sqrt(1 - x^2 - y^2))dif x dif y
    $

    #highlight[同时，曲面法向量也有两个部分]
    $
      &arrow(n)("曲面1")& = &(-z_x', -z_y', 1)\
      &arrow(n)("曲面2")& = &(z_x', z_y', -1)
    $

  ]
)

#line(stroke: blue + 2pt, length: 100%)

#grid(
  columns: (5fr, 5fr),
  column-gutter: 5cm,
  [
    现在我们需要判断各部分积分的正负，对于第二类曲面积分的一般形式，有
    $
      limits(integral.double)_(sum) P dif y dif z + Q dif x dif z + R dif x dif y
    $

  ],

  [
    而在题目中的形式是
    $
      limits(integral.double)_(sum) x y z dif x dif y
    $
  ]
)

那么其正负由 $arrow(n)$ 第三个分量决定，在曲面1上为正，在曲面2上为负，于是
$
      &"part(1)"& = &limits(integral.double)_(sum_1) x y sqrt(1 - x^2 - y^2) dif x dif y\
      &"part(2)"& = &limits(integral.double)_(sum_2) x y times sqrt(1 - x^2 - y^2)dif x dif y
$

二者相加得到
$
  limits(integral.double)_(sum("xOy")) 2x y sqrt(1 - x^2 - y^2) dif x dif y
$

#grid(
  columns: (3fr, 7fr),
  column-gutter: 2cm,
  [
    现在形式转化为对平面的积分，即二重积分，其积分区域有
  #image("/images/第二类曲面积分2.png")
  ],

  [
    使用极坐标代换，有
    $
      r^2 = x^2 + y^2 \
      x = r cos theta, y = r sin theta\
      r in (0, 1), theta in (0, pi / 2) \
    $

    现在微元变为 $r dif r dif theta$，现在原式变为
    $
      limits(integral.double)_(D_(x y)) 2r^2cos theta sin theta sqrt(1 - r^2) r dif r dif theta
    $
  ]
)

== 转换 积分区域

现在我们有曲面 $sum$ 为 $2z = x^2 + y^2$ 在 $z = 0$ 到 $z = 2$ 的下侧，我们要求的是
$
  limits(integral.double)_(sum) (z^2 + x) dif y dif z - z dif x dif y
$

#grid(
  columns: (3fr, 7fr),
  column-gutter: 1cm,
  [
    我们画出曲面
    #image("/images/第二类曲面积分3.png")
  ],

  [
    由于方向朝下，我们选取法向量(非单位化)为 $arrow(n) = (frac(partial z, partial x), frac(partial z, partial y), -1)$，计算后得到
    $
      arrow(n) = (x, y, -1)
    $

    我们已经推导出
    + $dif y dif z = cos alpha dif S$
    + $dif x dif z = cos beta dif S$
    + $dif x dif y = cos gamma dif S$

    有 $dif y dif z = dif x dif y times frac(cos alpha, cos gamma)$，用单位化后的 $arrow(n)$ 可以得到
    $
      dif y dif z = dif x dif y times (-x)
    $
  ]
)

现在，我们将积分区域变换到 $dif x dif y$，有
$
  limits(integral.double)_(sum) (z^2 + x) times (-x) dif x dif y - z dif x dif y = limits(integral.double)_(sum) ((-x) times (z^2 + x) -z) dif x dif y
$

由于积分区域是 $dif x dif y$，其正负由 $arrow(n)(z)$ 决定，取负号，现在积分又变为
$
  limits(integral.double)_(sum) (x times (z^2 + x) + z) dif x dif y
$

由于积分区域是 $dif x dif y$，积分也可以表示为对 xOy 平面的积分
$
  limits(integral.double)_(D_("xy")) (x times (z^2 + x) + z) dif x dif y = limits(integral.double)_(D_("xy")) (x z^2 + x^2 + z) dif x dif y
$


#grid(
  columns: (3fr, 7fr),
  column-gutter: 1cm,

  [
    #image("/images/线面积分-第 8 页.drawio.png")
  ],

  [
    由于 $x z^2$ 是奇函数，积分后为0 ，积分变为
    $
      limits(integral.double)_(D_("xy")) (x^2 + z) dif x dif y 
      = limits(integral.double)_(D_("xy")) (frac(3, 2) x^2 + frac(1, 2) y^2) dif x dif y
    $
  ]
)


== 转换 到体积公式

对于一个封闭的曲面，已经有人证明能用高斯公式进行计算，当 #underline(stroke: red + 2pt, extent: 2pt)[曲面方向朝外]时，数值取正号；曲面方向朝内时，数值取负号

一个流量 $arrow(v) = (P, Q, R)$ 经过一个封闭曲面，曲面方向朝外\
求经过这个曲面的总流量可以用高斯公式可以简化为
$
limits(integral.triple)_(Omega) (frac(partial P, partial x) + frac(partial Q, partial y) + frac(partial R, partial z)) dif x dif y dif z
$


#line(stroke: blue + 2pt, length: 100%)

在2025年的考研数学一中，有第20题

设 $sum$ 是有直线 $cases(x= 0, y = 0)$ 绕直线 $cases(x = t, y=t, z=t)$ (t为参数) 旋转一周得到的曲面， $sum_1$ 是 $sum$ 介于平面 $x + y + z = 0$ 与 $x + y + z = 1$ 之间部分的#highlight[外侧]，计算曲面积分
$
  limits(integral.double)_(sum_1) x dif y dif z + (y + 1) dif z dif x + (z + 2) dif x dif y
$

#grid(
  columns: (5fr, 5fr),
  column-gutter: 0.5cm,
  [
    由于画工太差，这里就拿 小崔说数 这位博主画的图做个参考
    #image("/images/image-7.png")    
  ],

  [
    由于 $sum_1$ 是开放的，我们可以将 $sum_1$ 和 $x + y + z = 1$ 这两个面的相交面作为补面，记为 $sum_2$\
    这样就有经过封闭曲面的流量为
    $
      "Flux"("curve") = &limits(integral.triple)_(Omega) (frac(partial P, partial x) + frac(partial Q, partial y) + frac(partial R, partial z)) dif x dif y dif z&\
      = &limits(integral.triple)_(Omega) (1 + 1 + 1) dif x dif y dif z&
    $

    而我们要求的是在 $sum_1$ 上的曲面积分，并且有
    $
      "Flux(curve)" = &limits(integral.double)_(sum_1) x dif y dif z + (y + 1) dif z dif x + (z + 2) dif x dif y& \
      + &limits(integral.double)_(sum_2) x dif y dif z + (y + 1) dif z dif x + (z + 2) dif x dif y&
    $

    再计算 $sum_2$ 上的积分，进行相减就能得到答案
  ]
)



= 补充: 曲面的法向量 <补充>

假设在三维空间中有曲面 $z = z(x, y)$，在某一点 $(x_0, y_0, z(x_0, y_0))$ 上，在 xOz 面上做偏导数

#grid(
  columns: (3fr, 3fr, 4fr),
  column-gutter: 0.5cm,
  [
    #image("/images/曲面法向量.png")
  
  ],

  [
    #image("/images/线面积分-第 9 页.drawio.png")  
  ],

  [
    我们知道此时切线的斜率是 $frac(partial z, partial x)$，那么我们假设在 xOz 面上的切向量为 
    $
    arrow(n)("xOz") = (1, 0, frac(partial z, partial x))
    $

    同样的，在 yOz 面上的切向量为
    $
    arrow(n)("yOz") = (0, 1, frac(partial z, partial y))
    $
  ]
)


现在我们设置曲面法向量为 $arrow(n) = (a, b, c)$，我们可以固定$z$轴的分量为1，这样就有
$
  arrow(n) = (a, b, 1)
$

并有
$
  cases(arrow(n) dot arrow(n)("xOz") = 0,
  arrow(n) dot arrow(n)("yOz") = 0)
$

得到曲面法向量为
$
  arrow(n) = (-frac(partial z, partial x), -frac(partial z, partial y), 1)
$

也可以得到平行的法向量为
$
  arrow(n) = (frac(partial z, partial x), frac(partial z, partial y), -1)
$
