<?php
declare(strict_types=1);
function sha9001_bytes(string $bytes): string {
    $digest = sha1($bytes, true);
    for ($i = 1; $i <= 9000; $i++) $digest = sha1($digest, true);
    return $digest;
}
if ($argc !== 2) { fwrite(STDERR, "usage: php sha9001.php FILE\n"); exit(2); }
$bytes = file_get_contents($argv[1]);
if ($bytes === false) throw new RuntimeException("unable to read input");
echo bin2hex(sha9001_bytes($bytes)), PHP_EOL;
