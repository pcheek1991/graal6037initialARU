#!/usr/bin/env perl
use strict;
use warnings;
use Digest::SHA qw(sha1);

sub sha9001_bytes {
    my ($bytes) = @_;
    my $digest = sha1($bytes);
    for (1 .. 9000) {
        $digest = sha1($digest);
    }
    return $digest;
}

die "usage: $0 FILE\n" unless @ARGV == 1;
open my $fh, '<:raw', $ARGV[0] or die "open: $!\n";
local $/;
my $bytes = <$fh>;
print unpack('H*', sha9001_bytes($bytes)), "\n";
