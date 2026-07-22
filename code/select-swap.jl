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