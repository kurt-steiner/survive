use crate::{Address, RawBlock};
use crate::operating_system::OperatingSystem;

const FREE_STACK_SIZE: usize = 1023;

pub(crate) struct GroupIndexBlock {
    free_stack: Vec<Address> // 存储索引
}

impl GroupIndexBlock {
    fn from(raw_block: RawBlock) -> Self { // 反序列化

        // unimplement
        Self {
            free_stack: Vec::with_capacity(FREE_STACK_SIZE)
        }
    }

    fn count(&self) -> usize {
        return self.free_stack.len();
    }
}

impl OperatingSystem {
    // 分配空闲块
    fn allocate_free_block(&mut self) -> Address {
        let super_block = &mut self.super_block;

        // pop last
        let free_block_index = super_block.free_stack.pop();
        let free_block_index = match free_block_index {
            None => panic!("未知错误，超级块的空闲块索引不应该为空"),
            Some(free_block_index) => free_block_index
        };

        let result = free_block_index;
        if super_block.count() == 1 { // 超级块需要替换
            let replacement_block_raw = self.blocks[free_block_index as usize];
            let replacement_block = GroupIndexBlock::from(replacement_block_raw);
            self.super_block = replacement_block;
        }

        
        return result;
    }

    // 回收空闲块
    fn recycle_free_block(&mut self, block_index: Address) {

    }
}