use crate::{Address, file::ConvertRawBlock, operating_system::OperatingSystem};

const DIRECTLY_ACCESS_BLOCK_COUNT: usize = 10;

pub(crate) struct FileControlBlock {
    pub(crate) size: u64,
    pub(crate) is_directory: bool,
    pub(crate) is_file: bool,
    pub(crate) is_block: bool,
    pub(crate) is_symlink: bool,
    pub(crate) is_hidden: bool,

    pub(crate) indexs_directly_access_block: Vec<Address>,
    pub(crate) index_one_level: Option<Address>,
    pub(crate) index_two_level: Option<Address>,
    pub(crate) index_three_level: Option<Address>
}

impl OperatingSystem {
    fn transfer_in_hybrid(&self, fcb: FileControlBlock) {
        assert!(fcb.is_file); // 确保不是目录

        for index in fcb.indexs_directly_access_block.iter() {
            let index = *index as usize;
            let block_raw = self.blocks[index];
            let data_block = block_raw.as_data();
            self.stream.send(data_block).expect("fuck");
        }

        if let Some(index_one_level) = fcb.index_one_level {
            self.transfer_in_one_level(index_one_level as usize);
        }
        
        if let Some(index_two_level) = fcb.index_two_level {
            self.transfer_in_two_level(index_two_level as usize);
        }

        if let Some(index_three_level) = fcb.index_three_level {
            // 懒得写，好麻烦
        }
    }
}