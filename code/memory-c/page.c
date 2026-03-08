#include <stdint.h>

struct Address {
    uint32_t offset_page; // 页号
    uint32_t offset_in_page; // 页内偏移
};

struct PageTable {
    uint32_t length; // 页表长度
    uint32_t element_size; // 一个页的大小，以字节为单位
    uint64_t * data;
};

struct Progress {
    struct PageTable * page_table;
};

uint32_t memory_block_size(struct Address address) {
    uint64_t result = 1;
    for (uint32_t offset_start = 1; offset_start <= address.offset_in_page; offset_start += 1) {
        result *= 2;
    }

    return result;
}

uint64_t progress_find_raw_address(struct Progress * progress, struct Address address) {
    struct PageTable * page_table = progress -> page_table;
    uint32_t block_size = memory_block_size(address);
    uint32_t offset = address.offset_page;

    if (offset >= page_table -> length) {
        // 发生了错误
        exit(1);
    }

    uint64_t offset_memory_lines = (page_table -> data)[offset]; // 内存块号/行号
    uint64_t raw_address = offset_memory_lines * block_size + address.offset_in_page;

    return raw_address;
}