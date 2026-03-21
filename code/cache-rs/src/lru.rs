const PAGE_FRAME_COUNT: usize = 8;

struct Page;

struct PageFrame {
    page_index: usize,
    page: Page,
    count: u8
}

struct Progress {
    page_frames: Vec<PageFrame>
}

impl Progress {
    fn new() -> Self {
        Self {
            page_frames: Vec::with_capacity(PAGE_FRAME_COUNT)
        }
    }

    fn access_page(&mut self, page_index: usize) {
        self.page_frames.iter_mut().for_each(|page_frame| {
            page_frame.count += 1;
        });

        let matched_page_frame = self.page_frames.iter_mut()
            .find(|page_frame| page_frame.page_index == page_index);

        if let Some(page_frame) = matched_page_frame {
            page_frame.count = 0;
        }
    }

    fn page_frame_index_to_swapout(&self) -> usize {
        self.page_frames.iter()
            .map(|page_frame| {
                page_frame.count
            })
            .enumerate()
            .reduce(|left, right| {
                std::cmp::max_by_key(left, right, |tuple| {
                    tuple.1
                })
            })
            .map(|tuple| {
                tuple.0
            })
            .unwrap_or(0) // 默认第一个页框置换
    }
}

