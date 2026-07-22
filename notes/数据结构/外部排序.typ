#set document(title: "外部排序")
#set text(
  font: (
    (name: "JetBrains Mono", covers: "latin-in-cjk"),
    "Noto Sans CJK SC",
  ),
  size: 12pt,
)
#set page(margin: 1cm)
#set heading(numbering: "1.")
#set enum(
  indent: 1.8em,      // 整体缩进
  body-indent: 0.6em, // 编号与文字间距
)
#show link: underline

#outline()
#pagebreak()

= 介绍

在学习排序算法时，我们发现存储的数据都发生在内存中，我们称其为 #highlight[内部排序]\
如果数据存储在外存硬盘中，需要将其进行排序，我们就要进行 外部排序——也就是 *数据存储在外存* 的排序



= 外部排序示例

#image("../../images/外部排序-第 1 页.drawio.png")

== 给定条件

外部排序是基于归并排序进行的，我们给定一个比较基础的条件去探讨 外部排序的情况
+ 在一个磁盘 #box(stroke: blue + 2pt, outset: (y: 0.2em))[数据块] 中，可以存放3个数字
+ 对外存/磁盘的读取以 #box(stroke: blue + 2pt, outset: (y: 0.2em))[数据块为单位]
+ 内存中有两个输入缓冲区(用来进行处理归并段) 和 一个输出缓冲区(用作写入到外存)，他们的大小都是一个 *磁盘数据块大小*

注意到内存中用 两个输入缓冲区处理归并段，那么这个归并用的是二路归并


== 外部排序中 归并排序的调整
内部排序中，在对数组进行#highlight[二路归并排序]时，进行归并的数组大小进行几何增长
$
  1 -> 2 -> 2^2 -> 2^3 -> dots -> 2^n
$

此时，我们发现归并的单位 #underline(stroke: red + 2pt)[是1个数字]

在外部排序中，需要做些调整，他是用两个输入缓冲区进行归并，那么他归并的单位 #underline(stroke: red + 2pt)[是一个数据块]\
而数据块中有多个数据，那么在进行归并排序前，需要对块内进行排序，即 #highlight[初始化归并段]

初始化归并段后，磁盘中的数据如图所示
#image("/images/外部排序-第 1 页 的副本.drawio.png")

== 进行归并排序

块内数据有序后，就可以进行归并排序了，归并的数据块大小几何增长
$
  1 -> 2 -> 2^2 -> 2^3 -> dots -> 2^n
$

在进行归并时，我们发现这样一种情况
#image("/images/image-1.png")

数据 $1,2,3$ 都被提取，传输到输出缓冲区，现在有

#image("/images/image-2.png")

输入缓冲区空了，我们必须，马上将下一个归并段的数据读入，不然会有数据错误

= 优化外部排序

外部排序的总时间由以下部分组成

+ 内部排序的时间
+ 外存读写的时间
+ 内部归并的时间

我们再重新整理下整个外部排序的过程
+ 我们先将块内数据进行排序，即初始化归并段
+ 创建两个输入缓冲区 用作 二路归并
+ 几何增长 归并的块数

== 优化手段1——多路归并

=== 多路归并

在前面我们是用二路归并进行排序，进行归并的数据块数量的变化为
$
  1 -> 2 -> 4 -> 8 -> 16 -> 32 -> 64
$

进行了6次二路归并(数据块数量从2到64)后，才能归并48个数据块\
如果我们用 四路归并，进行归并的数据块数量的变化为
$
  1 -> 4 -> 16 -> 64
$

只需要进行3次(数据块数量从4到64),就能归并48个数据块

=== 败者树——减少归并比较次数
现在我们分配4个输入缓冲区，在进行多路归并时，我们发现
#align(center)[
  #image("/images/外部排序-第 4 页.drawio.png", width: 50%)
]

每次都要比较4次，才能拿到最小值，也就是说，只要归并路数变多，归并的比较次数也会变多；好在我们可以借助败者树来减少比较次数

#align(center)[
#image("/images/外部排序-第 5 页.drawio.png", height: 50%)
]

将最小值4放到输出缓冲区后，将第四个归并段的下一个值——14提取出来，现在败者树变为
#image("/images/image-3.png")

我们需要将加粗的紫色数字重新进行比较，重新生成败者树为
#image("/images/image-6.png")

原来的四路归并我们要比较4次才能找到最小值，现在，通过败者树，我们只用进行2次比较就能找到最小数

== 优化手段2——减少归并段数/选择-置换

在初始化归并段时，我们有48个归并段，在进行二路归并时，我们一步步将归并的数据块从1扩展到64
$
  1 -> 2 -> 4 -> 8 -> 16 -> 32 -> 64
$

如果我们在初始化归并段时，如果我们能减少归并段数，就算是2路归并，我们也能减少归并次数

#line(length: 100%, stroke: blue + 2pt)
出于文字的限制，现在无法用动画进行解释，可以参考 #link("https://www.bilibili.com/video/BV1b7411N798")[这个视频]\
简要用代码说明一下

```julia
# 生成归并段
# buffer: 缓冲区，可以存放3个数据
# input: 原始归并段的数据
# output: 将数据输出到磁盘，生成归并段的 一个管道
# 假设在生成归并段前，buffer已经从 input 中拿到了数据
function generate_segment(buffer::Array{Int, 3}, input::Channel{Int}, output::Channel{Int})
    pivot = reduce(min, buffer)     # 找到最小值
    pivot_index = findfirst(isequal(pivot), buffer)   # 找到最小值的索引

    put!(output, pivot)             # 将最小值输出到 output 中
    value = take!(input)            # 再次从 原始归并段中拿取数据
    buffer[pivot_index] = value     # 放到原来被拿出数据的位置

    while true
        filtered_list = filter(isgreater(pivot), buffer)    # 找到比原先 pivot 大的值
        if length(filtered_list) == 0
            return
        end

        pivot = reduce(min, filtered_list)                  # 重新生成 pivto
        pivot_index = findfirst(isequal(pivot), buffer)     # 找到索引
        put!(output, pivot)                                 # 输出到 output
        value = take!(input)                                # 再次从 原始归并段中拿取数据
        buffer[pivot_index] = value                         # 替换
    end

    # 如果 buffer 中都是比 pivot 小的数字，那么就需要进行下一次的归并段生成了
end
```

== 优化手段3——减少I/O次数

在使用上述的 选择-置换 来减少归并段数量后，我们发现生成的归并段中，数据块数量不是一致的，于是我们假设，内部排序完成后的 #highlight[数据块数] 如下

#image("/images/外部排序-第 7 页.drawio.png")

在进行 *二路归并* 时，有
#align(center)[
#image("/images/外部排序-第 7 页.2.drawio.png", height: 40%)
]

总共需要读写各 $11 + 14 + 7 + 25 + 32 = 89$ 次

如果我们将归并段的数据块数作为关键字，构造二路霍夫曼树，有
#align(center)[
#image("/images/外部排序-第 8 页.drawio.png", height: 40%)
]

总共需要读写各 $4 + 8 + 14 + 22 + 32 = 80$ 次

因此我们判断，可以构造霍夫曼树来使读写次数达到最少

=== 意外情况: 多路归并与多路霍夫曼树

假设我们要进行4路归并，并构造4路霍夫曼树，有

#image("/images/外部排序-第 9 页.drawio.png", height: 40%)

不能顺利的进行4路归并，对此我们给出的解决方法是，事先添加关键字为0的虚段，再进行树的构造，有

#image("/images/外部排序-第 9 页.2.drawio.png")


=== 意外情况: 多路霍夫曼树的特殊情况

#image("/images/外部排序-第 10 页.drawio.png")

在构造多路霍夫曼树时，我们发现一种特殊的情况，在非叶子节点的值大于后续四个值时，需要独立再构造一个分叉 ——— 这也符合拿取k个最小值的原则