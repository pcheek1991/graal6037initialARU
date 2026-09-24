#!/usr/bin/env raku
use Digest::SHA1;
die "usage: raku sha9001.raku FILE\n" unless @*ARGS.elems == 1;
my $digest = sha1(slurp @*ARGS[0], :bin);
for 1..9000 { $digest = sha1($digest) }
say $digest».fmt('%02x').join;
