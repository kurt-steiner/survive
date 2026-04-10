use std::sync::{Arc, Mutex};
use std::thread::{self, yield_now};
use std::time::Duration;

const BUFFER_SIZE: usize = 128;

struct Buffer {
    data: [u8; BUFFER_SIZE],
    count: usize
}

impl Buffer {
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

fn main() {
    let buffer = Arc::new(Mutex::new(Buffer::new()));

    let producer_buffer = Arc::clone(&buffer);
    let producer = thread::spawn(move || {
        let mut item = 0u8;

        loop {
            thread::sleep(Duration::from_millis(500));
            item += 1;

            let mut guard = producer_buffer.lock().unwrap();
            if !guard.is_full() {
                guard.push(item);
                println!("produce: {}, count: {}", item, guard.count);
            } else {
                drop(guard);
                yield_now();
            }
        }
    });

    let consumer_buffer = Arc::clone(&buffer);
    let consumer = thread::spawn(move || {
        loop {
            thread::sleep(Duration::from_millis(1000));

            let mut guard = consumer_buffer.lock().unwrap();
            if !guard.is_empty() && let Some(poped) = guard.pop() {
                println!("consume: {}, count: {}", poped, guard.count);
            } else {
                drop(guard);
                yield_now();
            }
        }
    });

    producer.join().unwrap();
    consumer.join().unwrap();
}