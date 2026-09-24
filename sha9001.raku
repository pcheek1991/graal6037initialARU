#!/usr/bin/env raku
use Digest::SHA1;

sub sha9001(Blob:D $bytes --> Blob:D) {
    my $digest = sha1($bytes);
    for 1..9000 { $digest = sha1($digest) }
    $digest
}

sub hex(Blob:D $bytes --> Str:D) {
    $bytes.list».fmt('%02x').join
}

sub rotn(Str:D $value, Int:D $distance, $key --> Str:D) {
    die "ROT input contains a NUL character\n" if $value.contains("\0");
    die "ROT key is required\n" unless $key.defined;
    my $shift = $distance % 26;
    $value.comb.map({
        my $code = .ord;
        my $base = 65 <= $code <= 90 ?? 65 !! 97 <= $code <= 122 ?? 97 !! 0;
        $base == 0 ?? $_ !! ($base + (($code - $base + $shift) % 26)).chr
    }).join
}

sub rot13(Str:D $value, $key --> Str:D) { rotn($value, 13, $key) }
sub ebg13(Str:D $value, $key --> Str:D) { rotn($value, -13, $key) }

if @*ARGS.elems == 4 && @*ARGS[0] eq '--rot' {
    say rotn(@*ARGS[1], @*ARGS[2].Int, @*ARGS[3].encode('utf8'));
} elsif @*ARGS.elems == 1 {
    say hex sha9001(slurp @*ARGS[0], :bin);
} elsif @*ARGS.elems == 2 && @*ARGS[0] eq '--coreo' {
    my $baseline = sha9001(Buf[uint8].new(0 xx 21));
    my $distinct = 0;
    for 0..167 -> $bit {
        my $input = Buf[uint8].new(0 xx 21);
        $input[$bit div 8] = 1 +< ($bit mod 8);
        $distinct++ unless sha9001($input) eqv $baseline;
    }
    say "BASELINE=" ~ hex($baseline);
    say "PERTURBED_DISTINCT=$distinct";
    say "RESULT=" ~ ($distinct == 168 ?? 'PASS' !! 'FAIL');
} else {
    die "usage: raku sha9001.raku FILE|--coreo LABEL\n";
}
