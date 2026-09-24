#!/usr/bin/env tclsh
proc rotn {value distance key} {
    if {![string is integer -strict $distance]} { error "ROT distance must be an integer" }
    if {[string first "\x00" $value] >= 0} { error "ROT input contains NUL" }
    set shift [expr {(($distance % 26) + 26) % 26}]
    set result ""
    foreach char [split $value ""] {
        scan $char %c code
        if {$code >= 65 && $code <= 90} {
            append result [format %c [expr {65 + (($code - 65 + $shift) % 26)}]]
        } elseif {$code >= 97 && $code <= 122} {
            append result [format %c [expr {97 + (($code - 97 + $shift) % 26)}]]
        } else {
            append result $char
        }
    }
    return $result
}
proc rot13 {value key} { return [rotn $value 13 $key] }
proc ebg13 {value key} { return [rotn $value -13 $key] }

if {$argc == 4 && [lindex $argv 0] eq "--rot"} {
    puts [rotn [lindex $argv 1] [lindex $argv 2] [lindex $argv 3]]
    exit 0
}
if {$argc != 1} { puts stderr "usage: tclsh sha9001.tcl FILE | --rot VALUE DISTANCE KEY"; exit 2 }
package require sha1
set fh [open [lindex $argv 0] rb]
try {
    set bytes [read $fh]
} finally {
    close $fh
}
set digest [::sha1::sha1 $bytes -bin]
for {set i 1} {$i <= 9000} {incr i} {
    set digest [::sha1::sha1 $digest -bin]
}
binary encode hex $digest
puts ""
