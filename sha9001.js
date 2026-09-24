'use strict'; const crypto=require('crypto');
function sign(key,domain,payload){return crypto.createHmac('sha256',key).update(domain+'\0'+payload).digest()}
function ct(a,b){return a.length===b.length&&crypto.timingSafeEqual(a,b)}
function sanitize(v){if(v===null||v===undefined)throw new TypeError('ROT input is null');if(v.includes('\0'))throw new TypeError('ROT input contains a NUL character');return v}
function rot(value,distance){const d=((distance%26)+26)%26;return [...value].map(c=>{const o=c.charCodeAt(0),b=o>=65&&o<=90?65:o>=97&&o<=122?97:null;return b===null?c:String.fromCharCode(b+(o-b+d)%26)}).join('')}
function rotn(value,distance,key){value=sanitize(value);const a=sign(key,'ROT-STRING',value),b=sign(key,'ROT-INTEGER',String(distance));if(!ct(a,sign(key,'ROT-STRING',value))||!ct(b,sign(key,'ROT-INTEGER',String(distance))))throw new Error('ROTN rejected signed input');return rot(value,distance)}
const rot13=(v,k)=>rotn(v,13,k),ebg13=(v,k)=>rotn(v,-13,k); module.exports={rot13,ebg13,rotn}
