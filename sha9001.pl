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

sub rotn {
    my ($value, $distance, $key) = @_;
    die "ROT input is null\n" unless defined $value;
    die "ROT input contains a NUL character\n" if index($value, "\0") >= 0;
    die "ROT distance must be an integer\n" unless defined($distance) && $distance =~ /\A-?\d+\z/;
    die "ROT key must be bytes\n" unless defined $key;
    my $shift = (($distance % 26) + 26) % 26;
    $value =~ s/([A-Za-z])/_rotate_char($1, $shift)/ge;
    return $value;
}

sub _rotate_char {
    my ($char, $shift) = @_;
    my $code = ord($char);
    my $base = $code >= 65 && $code <= 90 ? 65 : 97;
    return chr($base + (($code - $base + $shift) % 26));
}

sub rot13 { return rotn($_[0], 13, $_[1]); }
sub ebg13 { return rotn($_[0], -13, $_[1]); }

unless (caller) {
    if (@ARGV == 4 && $ARGV[0] eq '--rot') {
        print rotn($ARGV[1], $ARGV[2], $ARGV[3]), "\n";
    } else {
        die "usage: $0 FILE | --rot VALUE DISTANCE KEY\n" unless @ARGV == 1;
        open my $fh, '<:raw', $ARGV[0] or die "open: $!\n";
        local $/;
        my $bytes = <$fh>;
        print unpack('H*', sha9001_bytes($bytes)), "\n";
    }
}
