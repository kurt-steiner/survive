use std::collections::VecDeque;

#[derive(PartialEq, Clone, Copy)]
enum Bracket {
    Left,
    Right
}

#[derive(Clone, Copy)]
enum Token {
    Number(i32),
    Bracket(Bracket),
    Operator(char)
}

fn priority(op: char) -> u32 {
    todo!()
}

fn infix_to_suffix(mut tokens: VecDeque<Token>) -> Option<Vec<Token>> {
    let mut output: Vec<Token> = Vec::new();
    let mut stack: Vec<Token> = Vec::new();

    while let Some(current_token) = tokens.pop_front() {
        match current_token {
            Token::Number(_) => output.push(current_token),
            Token::Bracket(bracket) => {
                if bracket == Bracket::Left {
                    stack.push(current_token);
                } else {
                    while let Some(op) = stack.pop() {
                        if let Token::Bracket(Bracket::Left) = op {
                            break;
                        }
                    }
                }
            }

            Token::Operator(op) => {
                let priority_op = priority(op);
                
                while let Some(Token::Operator(top_op)) = stack.last() {
                    let priority_top_op = priority(*top_op);
                    
                    if priority_op < priority_top_op {
                        match stack.pop() {
                            Some(poped) => output.push(poped),
                            None => return None
                        };
                    }
                }

                stack.push(current_token);
            }
        }
    }

    // rest
    while let Some(token) = stack.pop() {
        output.push(token);
    }

    return Some(output);
}

fn main() {

}