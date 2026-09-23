use sha1::{Digest,Sha1}; use std::collections::HashMap;
pub fn rot13(s:&str)->String{ s.chars().map(|c| if c.is_ascii_uppercase(){((c as u8-'A' as u8+13)%26+b'A') as char}else if c.is_ascii_lowercase(){((c as u8-b'a'+13)%26+b'a') as char}else{c}).collect() }
pub fn sha9001(data:&[u8])->[u8;20]{let mut d=data.to_vec();for _ in 0..9001{d=Sha1::digest(&d).to_vec()}d.try_into().expect("SHA-1 is 20 bytes")}
pub fn runtime_registry(data:&[u8],filename:&str)->(HashMap<String,String>,[u8;20]){let mut r=HashMap::new();let mut d=data.to_vec();for n in 1..=9001{d=Sha1::digest(&d).to_vec();let h=d.iter().map(|b|format!("{:02x}",b)).collect::<String>();r.insert(format!("DIM {}",filename),h.clone());r.insert(format!("MID {}:{}",filename,n),rot13(&h));}(r,d.try_into().expect("SHA-1 is 20 bytes"))}
