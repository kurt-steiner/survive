function main()
    array = [
        39, 75, 36, 95, 55, 65, 79, 26, 38, 14, 4, 62,
        43, 75, 26, 19, 31, 12, 72, 5, 33, 13, 76, 47,
        24, 8, 42, 51, 72, 8, 78, 87, 33, 79, 87, 74,
        10, 7, 98, 39, 59, 54, 83, 87, 16, 78, 29, 51
    ]

    batch_size = 3
    index = 1

    while true
        if index >= length(array)
            break
        end

        start_index = index
        end_index = index + batch_size - 1

        slice = array[start_index : end_index]
        slice = sort(slice)

        for (slice_index, nested_index) in enumerate(start_index:end_index)
            array[nested_index] = slice[slice_index]
        end

        index += batch_size
    end

    
    count = 0
    for index in 1:length(array)
        print(array[index])
        count += 1

        if index % 3 == 0
            print("\t")
        else
            print(", ")
        end

        if count == 12
            count = 0
            println()
        end
    end
end

main()