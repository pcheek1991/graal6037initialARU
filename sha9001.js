'use strict'; const crypto=require('crypto');
function sha9001(data){let d=Buffer.from(data);for(let i=0;i<9001;i++)d=crypto.createHash('sha1').update(d).digest();return d}
function sanitize(v){if(v===null||v===undefined)throw new TypeError('ROT input is null');if(v.includes('\0'))throw new TypeError('ROT input contains a NUL character');return v}
function rot(value,distance){const d=((distance%26)+26)%26;return [...value].map(c=>{const o=c.charCodeAt(0),b=o>=65&&o<=90?65:o>=97&&o<=122?97:null;return b===null?c:String.fromCharCode(b+(o-b+d)%26)}).join('')}
function rotn(value,distance,key){value=sanitize(value);if(!Number.isInteger(distance))throw new TypeError('ROT distance must be an integer');if(!Buffer.isBuffer(key)&&!(key instanceof Uint8Array))throw new TypeError('ROT key must be bytes');return rot(value,distance)}
const rot13=(v,k)=>rotn(v,13,k),ebg13=(v,k)=>rotn(v,-13,k); module.exports={sha9001,rot13,ebg13,rotn}
