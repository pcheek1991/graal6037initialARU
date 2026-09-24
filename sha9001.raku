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

if @*ARGS.elems == 1 {
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
