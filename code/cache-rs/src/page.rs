/* 
假设，32位机器，以字节为单位，一页 4KB
那有 2^20 页
用 20 位表示页号
用 12 位表示页内偏移  -> 2^12 = 4KB
*/

const PAGE_SIZE: u32 = 4096; //页面大小，4096kb
const PAGE_TABLE_SIZE: usize = 64;
struct Address {
    offset_page: usize, // 页号
    offset_in_page: u32 // 页内偏移
}

impl Address {
    fn from(logic_address: u32) -> Self {
        let offset_page = logic_address / PAGE_SIZE;
        let offset_in_page = logic_address % PAGE_SIZE;

        Self {
            offset_page: offset_page as usize,
            offset_in_page
        }
    }
}


struct PageTable {
    length: u32, // 页表长度
    data: [u32; PAGE_TABLE_SIZE] // 页表数据，对应 map<页号,内存块号>，页号由data数组的索引隐含给出
}

struct Progress {
    page_table: PageTable
}

impl Progress {
    fn find(&self, logic_address: u32) -> Option<u32> {
        let address = Address::from(logic_address);
        if address.offset_page >= self.page_table.length as usize {
            return None;
        }

        let offset_page = address.offset_page;
        let offset_memory_block = self.page_table.data[offset_page]; // 内存块号
        let address_memory_block = offset_memory_block * PAGE_SIZE; // 内存块号地址
        let raw_address = address_memory_block + address.offset_in_page;
        return Some(raw_address);
    }
}
