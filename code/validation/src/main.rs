use std::cmp::min;

fn main() {
    println!("Hello, world!");
}

fn f(m: u32, n: u32) -> bool {
    let negative_one: i32 = -1;
    negative_one.pow(m * n) == negative_one.pow(min(m, n))
    
}

#[test]
fn test_this() {
    for m in 2..=10 {
        for n in 2..=10 {
            println!("(-1)^({}{}) == (-1)^min({}, {}) ? {}", m, n, m, n, f(m, n));
        }
    }
}