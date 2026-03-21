mod file;
mod block;

pub(crate) use file::*;
pub(crate) use block::*;

use std::sync::mpsc::Sender;

/*
在这个例子中，我们设置
1. 使用32位地址
2. 一个物理存储块大小为 4KB
*/

const BLOCK_SIZE: usize = 4096; // 一个物理存储块的大小是4KB
type Address = u32;
type RawBlock = [u8; BLOCK_SIZE];

struct OperatingSystem {
    blocks: Vec<RawBlock>, // 由于硬盘容量不一定，这里用 动态/不定长 数组表示
    stream: Sender<DataBlock>
}


impl OperatingSystem {
    fn lookup_in_directory(&self, filename: String, directory_fcb: FileControlBlock) -> Option<FileControlBlock> {
        let block_raw = self.blocks[directory_fcb.index_start_block];
        let block_directory = block_raw.as_directory();
        block_directory.0.iter().find(|entry| entry.filename == filename)
            .map(|entry| entry.fcb)
    }

    fn transfer_in_one_level(&self, fcb: FileControlBlock) {
        assert!(fcb.is_file); // 先确保不是目录

        let block_raw = self.blocks[fcb.index_start_block];
        let block_index = block_raw.as_index();
        block_index.0.iter().for_each(|index| {
            let index_block_data = *index as usize;
            let block_raw_inside = self.blocks[index_block_data];
            let block_data = block_raw_inside.as_data();
            self.stream.send(block_data).expect("fuck");
        });
    }

    fn transfer_in_two_level(&self, fcb: FileControlBlock) {
        assert!(fcb.is_file); // 先确保不是目录
        let block_raw = self.blocks[fcb.index_start_block];
        let block_index_one_level = block_raw.as_index();

        for index_one_level in block_index_one_level.0.iter() {
            let index_one_level = *index_one_level as usize;
            let block_two_level_raw = self.blocks[index_one_level];
            let block_two_level = block_two_level_raw.as_index();

            for index_two_level in block_two_level.0.iter() {
                let index_block_data = *index_two_level as usize;
                let block_two_level_raw = self.blocks[index_block_data];
                let block_data = block_two_level_raw.as_data();
                self.stream.send(block_data).expect("fuck");
            }
        }
    }

    fn transfer_in_hybrid(&self, fcb: FileControlBlock) {
        assert!(fcb.is_file);
        
        let block_raw = self.blocks[fcb.index_start_block];
        let block_index = block_raw.as_index();
        // 1. 直接块 addr(0) - addr(9)
        for offset in 0..=9 {
            let index = block_index.0[offset] as usize;
            let block_data_raw = self.blocks[index];
            let block_data = block_data_raw.as_data();
            self.stream.send(block_data).expect("fuck");
        }
        // 2. 一级索引 addr(10)
        let block_one_level_start = block_index.0[10] as usize;
        let block_one_level_raw = self.blocks[block_one_level_start];
        let block_one_level = block_one_level_raw.as_index();

        for index in block_one_level.0.iter() {
            let block_data_index = *index as usize;
            let block_data_raw = self.blocks[block_data_index];
            let block_data = block_data_raw.as_data();
            self.stream.send(block_data).expect("fuck");
        }
        // 3. 二级索引 addr(11)
        let block_two_level_start = block_index.0[11] as usize;
        let block_two_level_raw = self.blocks[block_two_level_start];
        let block_two_level = block_two_level_raw.as_index();
        for index in block_two_level.0.iter() {
            let block_next_level_index = *index as usize;
            let block_next_level_raw = self.blocks[block_next_level_index];
            let block_next_level = block_next_level_raw.as_index();

            for index in block_next_level.0.iter() {
                let block_data_index = *index as usize;
                let block_data_raw = self.blocks[block_data_index];
                let block_data = block_data_raw.as_data();
                self.stream.send(block_data).expect("fuck");
            }
        }

        // 4. 三级索引 addr(12)
        // 不写了，麻烦死了
    }
}