use crate::RawBlock;
use crate::file::*;
use crate::file_system::SuperBlock;

use std::sync::mpsc::Sender;


pub(crate) struct OperatingSystem {
    pub(crate) blocks: Vec<RawBlock>, // 由于硬盘容量不一定，这里用 动态/不定长 数组表示
    pub(crate) stream: Sender<DataBlock>,
    pub(crate) super_block: SuperBlock
}


