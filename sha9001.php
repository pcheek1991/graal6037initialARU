<?php
declare(strict_types=1);

function sha9001_bytes(string $bytes): string
{
    $digest = sha1($bytes, true);
    for ($i = 1; $i <= 9000; $i++) {
        $digest = sha1($digest, true);
    }
    return $digest;
}

function rotn(string $value, int $distance, string $key): string
{
    if (strpos($value, "\0") !== false) {
        throw new InvalidArgumentException("ROT input contains a NUL character");
    }
    $shift = (($distance % 26) + 26) % 26;
    return preg_replace_callback('/[A-Za-z]/', static function (array $match) use ($shift): string {
        $code = ord($match[0]);
        $base = $code >= 65 && $code <= 90 ? 65 : 97;
        return chr($base + (($code - $base + $shift) % 26));
    }, $value);
}

function rot13(string $value, string $key): string
{
    return rotn($value, 13, $key);
}

function ebg13(string $value, string $key): string
{
    return rotn($value, -13, $key);
}

if (isset($_SERVER['SCRIPT_FILENAME']) && realpath($_SERVER['SCRIPT_FILENAME']) === __FILE__) {
    if ($argc === 5 && $argv[1] === '--rot') {
        echo rotn($argv[2], (int)$argv[3], $argv[4]), PHP_EOL;
        exit(0);
    }
    if ($argc !== 2) {
        fwrite(STDERR, "usage: php sha9001.php FILE | --rot VALUE DISTANCE KEY\n");
        exit(2);
    }
    $bytes = file_get_contents($argv[1]);
    if ($bytes === false) {
        throw new RuntimeException("unable to read input");
    }
    echo bin2hex(sha9001_bytes($bytes)), PHP_EOL;
}
