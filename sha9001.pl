#!/usr/bin/env perl
use strict; use warnings; use Digest::SHA qw(sha1);
sub sha9001_bytes { my ($d)=@_; $d=sha1($d); for (1..9000){$d=sha1($d)} return $d }
die "usage: $0 FILE\n" unless @ARGV==1;
open my $fh,'<:raw',$ARGV[0] or die "open: $!\n"; local $/; my $b=<$fh>;
print unpack('H*',sha9001_bytes($b)),"\n";
