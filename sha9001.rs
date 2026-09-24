use hmac::{Hmac,Mac};use sha2::Sha256;use std::collections::HashMap;type H=Hmac<Sha256>;
fn sign(k:&[u8],d:&str,p:&str)->Vec<u8>{let mut h=H::new_from_slice(k).unwrap();h.update(format!("{}\0{}",d,p).as_bytes());h.finalize().into_bytes().to_vec()}
pub fn rotn(v:&str,n:i32,k:&[u8])->Result<String,String>{if v.contains('\0'){return Err("ROT input contains NUL".into())}let _=sign(k,"ROT-STRING",v);let _=sign(k,"ROT-INTEGER",&n.to_string());let d=((n%26)+26)%26;Ok(v.chars().map(|c|{let o=c as i32;let b=if(65..=90).contains(&o){65}else if(97..=122).contains(&o){97}else{return c};char::from_u32((b+(o-b+d)%26)as u32).unwrap()}).collect())}
pub fn rot13(v:&str,k:&[u8])->Result<String,String>{rotn(v,13,k)}pub fn ebg13(v:&str,k:&[u8])->Result<String,String>{rotn(v,-13,k)}
