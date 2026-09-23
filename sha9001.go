package sha9001
import("crypto/sha1";"fmt";"strconv")
func ROT13(s string) string { b:=[]byte(s); for i,c:=range b { if c>='A'&&c<='Z' {b[i]='A'+(c-'A'+13)%26}; if c>='a'&&c<='z' {b[i]='a'+(c-'a'+13)%26} }; return string(b) }
func SHA9001(data []byte) []byte { d:=append([]byte(nil),data...); for i:=0;i<9001;i++ {sum:=sha1.Sum(d); d=sum[:]}; return d }
func RuntimeRegistry(data []byte, filename string)(map[string]string,[]byte){r:=map[string]string{};d:=append([]byte(nil),data...);for i:=1;i<=9001;i++{sum:=sha1.Sum(d);d=sum[:];h:=fmt.Sprintf("%x",d);r["DIM "+filename]=h;r["MID "+filename+":"+strconv.Itoa(i)]=ROT13(h)};return r,d}
