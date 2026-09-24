#!/usr/bin/env tclsh
package require sha1
if {$argc != 1} { puts stderr "usage: tclsh sha9001.tcl FILE"; exit 2 }
set fh [open [lindex $argv 0] rb]; set digest [::sha1::sha1 [read $fh] -bin]; close $fh
for {set i 1} {$i <= 9000} {incr i} { set digest [::sha1::sha1 $digest -bin] }
puts [binary encode hex $digest]
