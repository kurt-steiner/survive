mod file;
mod file_system;
mod operating_system;

const BLOCK_SIZE: usize = 4096; // 一个物理存储块的大小是4KB
type Address = u32;
type RawBlock = [u8; BLOCK_SIZE];