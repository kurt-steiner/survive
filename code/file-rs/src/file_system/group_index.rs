use crate::{Address, RawBlock};
use crate::operating_system::OperatingSystem;

const FREE_STACK_SIZE: usize = 1023;

pub(crate) struct GroupIndexBlock {
    count: usize,
    free_stack: [Address; FREE_STACK_SIZE]
}

pub(crate) struct SuperBlock {
    block: GroupIndexBlock,
    block_index: usize
}


impl GroupIndexBlock {
    fn from(raw_block: RawBlock) -> Self { // 反序列化
        // unimplement
        todo!()
    }

    fn count(&self) -> usize {
        self.count
    }

    fn is_full(&self) -> bool {
        self.count() == FREE_STACK_SIZE
    }

    fn is_empty(&self) -> bool {
        self.count() == 0
    }

    fn pop(&mut self) -> Address {
        if self.count == 0 {
            panic!("内部错误，不应该在现在调用 pop");
        }

        let offset = self.count - 1;
        self.count -= 1;
        return self.free_stack[offset];
    }

    fn push(&mut self, data: Address) {
        if self.count == FREE_STACK_SIZE {
            panic!("内部错误，不应该在现在调用 push");
        }

        let offset = self.count;
        self.count += 1;
        self.free_stack[offset] = data;
    }

    fn is_last_block(&self) -> bool {
        self.free_stack[0] == Address::MAX // 其实就是 -1
    }

    fn clear(&mut self) {
        self.count = 0;
        self.free_stack = [0; FREE_STACK_SIZE];
    }
}

impl SuperBlock {
    fn pop(&mut self) -> Address {
        self.block.pop()
    }

    fn push(&mut self, data: Address) {
        self.block.push(data)
    }

    fn is_empty(&self) -> bool {
        self.block.is_empty()
    }

    fn is_full(&self) -> bool {
        self.block.is_full()
    }
}

impl OperatingSystem {
    // 分配空闲块
    fn allocate_free_block(&mut self) -> Address {
        
        /* if self.super_block.count() == 1 {
            let poped = self.super_block.pop();
            let next_block_raw = self.blocks[poped as usize];
            let next_block = GroupIndexBlock::from(next_block_raw);
            self.super_block = next_block;
            return self.super_block.pop();
        } else {
            return self.super_block.pop();
        } */

        // 对上面代码的改进
        let poped = self.super_block.pop();
        let mut result = poped;
        if self.super_block.is_empty() {
            let next_block_raw = self.blocks[poped as usize];
            let next_block = GroupIndexBlock::from(next_block_raw);
            self.super_block = SuperBlock {
                block: next_block,
                block_index: poped as usize
            };
            
            result = self.super_block.pop();
        }

        return result;
    }

    // 回收空闲块
    fn recycle_free_block(&mut self, block_index: usize) {

        if self.super_block.is_full() {
            let recycled_block_raw = self.blocks[block_index];
            let mut recycled_block = GroupIndexBlock::from(recycled_block_raw);
            recycled_block.clear();
            let original_super_block_index = self.super_block.block_index;
            recycled_block.push(original_super_block_index as u32);

            self.super_block = SuperBlock {
                block: recycled_block,
                block_index
            };
        } else {
            self.super_block.push(block_index as u32)
        }

        
    }
}