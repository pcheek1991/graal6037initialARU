//! SHA-9001: SHA-1 applied 9,001 times. Requires the sha1 crate.
use sha1::{Digest, Sha1};
pub fn sha9001(data: &[u8]) -> [u8; 20] { let mut digest=data.to_vec(); for _ in 0..9001 { digest=Sha1::digest(&digest).to_vec(); } digest.try_into().expect("SHA-1 output is 20 bytes") }
