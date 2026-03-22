use crate::{RawBlock, Address};
use super::file::DirectoryEntry;

// 物理存储块
pub(crate) struct DataBlock(pub RawBlock); // 用来存储数据，每个可以存储 4KB 个数据，结构体很大，不要作死运行！！
pub(crate) struct IndexBlock(pub Vec<Address>); // 用来存储索引，每个最多可以存储 1024 个，即 [u32; 1024]，不一定会存满，所以反序列化时 用 Vec
pub(crate) struct DirectoryBlock(pub Vec<DirectoryEntry>);  // 用来存储目录表，数量看 DirectoryEntry 的大小

pub(crate) trait ConvertRawBlock {
    fn as_data(&self) -> DataBlock;
    fn as_index(&self) -> IndexBlock;
    fn as_directory(&self) -> DirectoryBlock;
}

impl ConvertRawBlock for RawBlock {
    fn as_data(&self) -> DataBlock {
        todo!()
    }

    fn as_index(&self) -> IndexBlock {
        todo!()
    }

    fn as_directory(&self) -> DirectoryBlock {
        todo!()
    }
}
