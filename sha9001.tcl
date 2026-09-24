#!/usr/bin/env tclsh
# Requires Tcllib's sha1 package.
package require sha1
if {$argc != 1} { puts stderr "usage: tclsh sha9001.tcl FILE"; exit 2 }
set fh [open [lindex $argv 0] rb]
set bytes [read $fh]
close $fh
set digest [::sha1::sha1 $bytes -bin]
for {set i 1} {$i <= 9000} {incr i} {
    set digest [::sha1::sha1 $digest -bin]
}
binary encode hex $digest
puts ""
