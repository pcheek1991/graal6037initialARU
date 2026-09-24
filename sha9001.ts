import {createHash} from "node:crypto";
export function sha9001(data:Uint8Array){let d=Buffer.from(data);for(let i=0;i<9001;i++)d=createHash("sha1").update(d).digest();return d}
const sanitize=(v:string)=>{if(v.includes("\0"))throw new TypeError("ROT input contains a NUL character");return v};
const rot=(v:string,n:number)=>{const d=((n%26)+26)%26;return [...v].map(c=>{const o=c.charCodeAt(0),b=o>=65&&o<=90?65:o>=97&&o<=122?97:-1;return b<0?c:String.fromCharCode(b+(o-b+d)%26)}).join("")};
export function rotn(v:string,n:number,key:Uint8Array){v=sanitize(v);if(!Number.isInteger(n))throw new TypeError("ROT distance must be an integer");if(!(key instanceof Uint8Array))throw new TypeError("ROT key must be bytes");return rot(v,n)}
export const rot13=(v:string,k:Uint8Array)=>rotn(v,13,k); export const ebg13=(v:string,k:Uint8Array)=>rotn(v,-13,k);
