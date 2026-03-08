const CACHE_LINE_NUMBER: usize = 64;
const MEMORY_BLOCK_SIZE: usize = 13;

mod mapping_full {
    use super::CACHE_LINE_NUMBER;

    struct Address {
        index_of_memory_lines: usize,
        offset_in_block: usize
    }

    impl Address {
        fn from(raw_address: u64) -> Self {
            todo!()
        }
    }

    struct CacheLine {
        metadata: CacheLineMetadata,
        offset_of_memory_lines: usize,
        data_copied: u64,
    }

    struct CacheLineMetadata {
        is_dirty: bool,
        is_valid: bool
    }

    struct Cache {
        lines: [CacheLine; CACHE_LINE_NUMBER]
    }

    impl Cache {
        fn find(&self, raw_address: u64) -> Option<&CacheLine> {
            let address = Address::from(raw_address);
            self.lines.iter().find(|line| {
                line.offset_of_memory_lines == address.index_of_memory_lines
            })
        }
    }
}

mod mapping_directly {
    use super::CACHE_LINE_NUMBER;

    struct Address {
        index_of_memory_group: usize,
        index_in_memory_group: usize,
        offset_in_block: usize
    }

    impl Address {
        fn from(raw_address: u64) -> Self {
            todo!()
        }
    }

    struct CacheLine {
        metadata: CacheLineMetadata,
        index_of_memory_group: usize,
        data_copied: u64,
    }

    struct CacheLineMetadata {
        is_dirty: bool,
        is_valid: bool
    }

    struct Cache {
        lines: [CacheLine; CACHE_LINE_NUMBER]
    }

    impl Cache {
        fn find(&self, raw_address: u64) -> Option<&CacheLine> {
            let address = Address::from(raw_address);
            let cache_line = &self.lines[address.index_of_memory_group];
            
            if cache_line.index_of_memory_group == address.index_of_memory_group {
                Some(cache_line)
            } else {
                None
            }
        }
    }
}

mod mapping_group {
    struct Address {
        index_of_memory_group: usize,
        index_in_memory_group: usize,
        offset_in_block: usize
    }

    impl Address {
        fn from(raw_address: u64) -> Self {
            todo!()
        }
    }

    struct CacheLine {
        metadata: CacheLineMetadata,
        index_of_memory_group: usize,
        data_copied: u64,
    }

    struct CacheLineMetadata {
        is_dirty: bool,
        is_valid: bool
    }

    struct Cache {
        number_in_group: usize,
        lines: [CacheLine; super::CACHE_LINE_NUMBER]
    }

    impl Cache {
        fn find(&self, raw_address: u64) -> Option<&CacheLine> {
            let address = Address::from(raw_address);
            let index_cache_group = address.index_in_memory_group;
            let index_cache_line = index_cache_group * self.number_in_group;
            
            let mut start_index = index_cache_line;

            let mut loop_count = 0;
            while loop_count < self.number_in_group {
                let cache_line = &self.lines[start_index];
                if cache_line.index_of_memory_group == address.index_of_memory_group {
                    return Some(cache_line);
                }

                start_index += 1;
                loop_count += 1;
            }

            return None;
        }
    }
}

#[test]
fn mapping_directly() {
    let count_cache_line = 4;
    (0..=15).for_each(|address| {
        println!("{} mod {} = {}", address, count_cache_line, address % count_cache_line);
    });
}