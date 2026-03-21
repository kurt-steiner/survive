const PAGE_FRAME_COUNT: usize = 8;
struct Page;

struct PageFrame {
    page_index: usize,
    page: Page,
    access: bool
}

struct Progress {
    page_frames: Vec<PageFrame>,
    cursor: usize
}

impl Progress {
    fn new() -> Self {
        Self {
            page_frames: Vec::with_capacity(PAGE_FRAME_COUNT),
            cursor: 0
        }
    }

    fn access_page(&mut self, page_index: usize) {
        let matched_page_frame = self.page_frames.iter_mut().find(|page_frame| page_frame.page_index == page_index);

        if let Some(page_frame) = matched_page_frame {
            page_frame.access = true;
        }
    }

    fn page_frame_index_to_swapout(&mut self) -> usize {
        loop {
            let page_frame = &mut self.page_frames[self.cursor];
            if !page_frame.access { // 访问位为0,置换
                let current_cursor = self.cursor;
                self.cursor_next(); // 跳到下一页，方便下次循环继续
                return current_cursor;
            }

            page_frame.access = false; // 将访问位置为 0
            self.cursor_next();
        }
    }

    fn cursor_next(&mut self) {
        if self.cursor == PAGE_FRAME_COUNT {
            self.cursor = 0;
        } else {
            self.cursor += 1;
        }
    }
}

