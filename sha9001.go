package sha9001
import "crypto/sha1"
func SHA9001(data []byte) []byte { digest := append([]byte(nil), data...); for i := 0; i < 9001; i++ { sum := sha1.Sum(digest); digest = sum[:] }; return digest }
