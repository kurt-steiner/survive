struct Address {
    segment_index: usize,
    offset_in_segment: u32
}

struct SegmentTableItem {
    segment_length: u32,
    segment_address: u32
}

struct SegmentTable {
    items: Vec<SegmentTableItem> // 段号 由 索引隐含给出
}

struct Progress {
    segment_table: SegmentTable
}

impl Progress {
    fn find(&self, address: Address) -> Option<u32> {
        if address.segment_index >= self.segment_table.items.len() {
            return None; // 越界中断
        }

        let item = &self.segment_table.items[address.segment_index];
        let segment_length = item.segment_length;
        let segment_address = item.segment_address;

        if address.offset_in_segment >= segment_length {
            return None; // 越界中断
        }

        let raw_address = segment_address + address.offset_in_segment;
        return Some(raw_address);
    }
}
