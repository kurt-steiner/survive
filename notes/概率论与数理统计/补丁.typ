#set document(title: "补丁")
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

= 协方差
$
  Z = (X - E(X)) times (Y - E(Y)) \
  cov(X, Y) = E(Z)
$
= 相关系数

$
  rho = frac(cov(X, Y), sqrt(D(X)) times sqrt(D(Y)))
$