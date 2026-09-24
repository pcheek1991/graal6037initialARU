use sha1::{Digest as Sha1Digest, Sha1};
pub fn sha9001(data:&[u8])->Vec<u8>{let mut d=data.to_vec();for _ in 0..9001{let mut h=Sha1::new();h.update(&d);d=h.finalize().to_vec()}d}
pub fn rotn(v:&str,n:i32,_k:&[u8])->Result<String,String>{if v.contains('\0'){return Err("ROT input contains NUL".into())}let d=((n%26)+26)%26;Ok(v.chars().map(|c|{let o=c as i32;let b=if(65..=90).contains(&o){65}else if(97..=122).contains(&o){97}else{return c};char::from_u32((b+(o-b+d)%26)as u32).unwrap()}).collect())}
pub fn rot13(v:&str,k:&[u8])->Result<String,String>{rotn(v,13,k)}pub fn ebg13(v:&str,k:&[u8])->Result<String,String>{rotn(v,-13,k)}
