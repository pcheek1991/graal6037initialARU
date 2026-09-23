sha9001 <- function(data) { if (!requireNamespace("openssl", quietly=TRUE)) stop("Install openssl"); digest <- as.raw(data); for(i in seq_len(9001)) digest <- openssl::sha1(digest, raw=TRUE); digest }
sha9001_file <- function(path) sha9001(readBin(path,"raw",n=file.info(path)$size))
