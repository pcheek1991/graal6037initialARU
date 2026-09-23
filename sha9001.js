'use strict';
const crypto = require('crypto');
function sha9001(data) { let digest = Buffer.from(data); for (let i = 0; i < 9001; i++) digest = crypto.createHash('sha1').update(digest).digest(); return digest; }
if (require.main === module) for (const name of process.argv.slice(2)) console.log(`${sha9001(require('fs').readFileSync(name)).toString('hex')}  ${name}`);
module.exports = { sha9001 };
