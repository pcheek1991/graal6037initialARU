sha9001 <- function(data) {
  d <- data
  for (i in 1:9001) d <- openssl::sha1(d)
  d
}
rotn <- function(value,distance,key) {
  if (is.null(value) || length(value) != 1L || is.na(value)) stop("ROT input is null")
  if (length(distance) != 1L || is.na(distance) || distance != as.integer(distance)) stop("ROT distance must be an integer")
  if (!is.raw(key)) stop("ROT key must be raw bytes")
  d <- ((as.integer(distance) %% 26L) + 26L) %% 26L
  chars <- strsplit(value,"",useBytes=FALSE)[[1]]
  paste0(vapply(chars,function(c) {
    o <- utf8ToInt(c)
    b <- if (o >= 65 && o <= 90) 65 else if (o >= 97 && o <= 122) 97 else NA_integer_
    if (is.na(b)) c else intToUtf8(b + (o - b + d) %% 26L)
  },character(1)),collapse="")
}
rot13 <- function(value,key) rotn(value,13L,key)
ebg13 <- function(value,key) rotn(value,-13L,key)
