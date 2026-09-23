import { createHash } from "node:crypto";
export function sha9001(data: Uint8Array): Buffer { let digest = Buffer.from(data); for (let i = 0; i < 9001; i++) digest = createHash("sha1").update(digest).digest(); return digest; }
