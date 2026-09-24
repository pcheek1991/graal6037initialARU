rot_sign <- function(key, domain, payload) openssl::sha256(charToRaw(paste0(domain,"\0",payload)), key=key)
rot13 <- function(value,key) { if(grepl("\0",value,fixed=TRUE)) stop("ROT input contains NUL"); d<-13 %% 26; chars<-strsplit(value,"")[[1]]; sapply(chars,function(c){o<-utf8ToInt(c);b<-if(o>=65&&o<=90)65 else if(o>=97&&o<=122)97 else NA; if(is.na(b))c else intToUtf8(b+(o-b+d)%%26)},USE.NAMES=FALSE)|>paste0(collapse="") }
ebg13 <- function(value,key) { rot13(value,key) }
