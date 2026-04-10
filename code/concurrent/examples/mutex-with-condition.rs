use std::{sync::{Arc, Condvar, Mutex}, thread, time::Duration};

const BUFFER_SIZE: usize = 128;
struct SharedBuffer {
    data: [u8; BUFFER_SIZE],
    count: usize
}

impl SharedBuffer {
    fn new() -> Self {
        Self {
            data: [0; BUFFER_SIZE],
            count: 0
        }
    }

    fn is_full(&self) -> bool {
        self.count == BUFFER_SIZE
    }

    fn is_empty(&self) -> bool {
        self.count == 0
    }

    fn push(&mut self, item: u8) {
        self.data[self.count] = item;
        self.count += 1;
    }

    fn pop(&mut self) -> Option<u8> {
        return if self.count == 0 {
            None
        } else {
            self.count -= 1;
            Some(self.data[self.count])
        }
    }
}

struct Buffer {
    buffer: Mutex<SharedBuffer>,
    not_full: Condvar,
    not_empty: Condvar
}

impl Buffer {
    fn new() -> Self {
        Self {
            buffer: Mutex::new(SharedBuffer::new()),
            not_full: Condvar::new(),
            not_empty: Condvar::new()
        }
    }

    fn produce(&self, item: u8) {
        let mut guard = self.buffer.lock().unwrap();

        while guard.is_full() {
            guard = self.not_full.wait(guard).unwrap();
        }

        guard.push(item);
        println!("produce {}, count: {}", item, guard.count);
        self.not_empty.notify_one();
    }

    fn consume(&self) -> u8 {
        let mut guard = self.buffer.lock().unwrap();

        while guard.is_empty() {
            guard = self.not_empty.wait(guard).unwrap();
        }

        let item = guard.pop().unwrap();
        println!("consume: {}, count: {}", item, guard.count);
        self.not_full.notify_one();

        item
    }
}

fn main() {
    let buffer = Arc::new(Buffer::new());

    let producer_buffer = Arc::clone(&buffer);
    let producer = thread::spawn(move || {
        let mut item = 0u8;
        loop {
            thread::sleep(Duration::from_millis(599));
            item += 1;
            producer_buffer.produce(item);
        }
    });

    let consumer_buffer = Arc::clone(&buffer);
    let consumer = thread::spawn(move || {
        loop {
            thread::sleep(Duration::from_millis(1000));
            consumer_buffer.consume();
        }
    });

    producer.join().unwrap();
    consumer.join().unwrap();
}