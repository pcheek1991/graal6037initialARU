package sha9001
import("crypto/hmac";"crypto/sha1";"crypto/sha256";"errors";"strconv")
func sign(k []byte,d,p string)[]byte{h:=hmac.New(sha256.New,k);h.Write([]byte(d+"\x00"+p));return h.Sum(nil)}
func ROTN(v string,n int,k []byte)(string,error){for _,c:=range v{if c==0{return "",errors.New("ROT input contains NUL")}}; stringSig:=sign(k,"ROT-STRING",v); intSig:=sign(k,"ROT-INTEGER",strconv.Itoa(n)); if !hmac.Equal(stringSig,sign(k,"ROT-STRING",v))||!hmac.Equal(intSig,sign(k,"ROT-INTEGER",strconv.Itoa(n))){return "",errors.New("ROTN rejected signed input")};d:=((n%26)+26)%26;out:=[]rune(v);for i,c:=range out{if c>='A'&&c<='Z'{out[i]=rune(65+(int(c)-65+d)%26)}else if c>='a'&&c<='z'{out[i]=rune(97+(int(c)-97+d)%26)}};return string(out),nil}
func ROT13(v string,k []byte)(string,error){return ROTN(v,13,k)}
func EBG13(v string,k []byte)(string,error){return ROTN(v,-13,k)}
func SHA9001(data []byte)[]byte{d:=append([]byte(nil),data...);for i:=0;i<9001;i++{s:=sha1.Sum(d);d=s[:]};return d}
