'use strict';
const crypto = require('crypto');
function rot13(text) { return text.replace(/[A-Za-z]/g, c => String.fromCharCode((c <= 'Z' ? 65 : 97) + (c.charCodeAt(0) - (c <= 'Z' ? 65 : 97) + 13) % 26)); }
function sha9001(data) { let digest = Buffer.from(data); for (let i = 1; i <= 9001; i++) digest = crypto.createHash('sha1').update(digest).digest(); return digest; }
function runtimeRegistry(data, filename) { const registry = {}; let digest = Buffer.from(data); for (let i = 1; i <= 9001; i++) { digest = crypto.createHash('sha1').update(digest).digest(); const h = digest.toString('hex'); registry[`DIM ${filename}`] = h; registry[`MID ${filename}:${i}`] = rot13(h); } return { registry, digest }; }
module.exports = { rot13, sha9001, runtimeRegistry };
