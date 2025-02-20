if { $argc > 0 } {
  set build_dir [lindex $argv 0]
} else {
  puts "### ERROR: 1st argument unspecified (build_dir)"
  exit -1
}

if { $argc > 1 } {
  set preferred_language [lindex $argv 1]
} else {
  puts "### WARNING: 2nd argument unspecified (preferred language): setting it to default: VHDL"
  set preferred_language "VHDL"
}

if { $argc > 2 } {
  set preferred_simulation_type [lindex $argv 2]
} else {
  puts "### WARNING: 3rd argument unspecified (preferred simulation type): setting it to default: rtl"
  set preferred_simulation_type "rtl"
}

if { $argc > 3 } {
  set fpga_part [lindex $argv 3]
} else {
  puts "### ERROR: 4th argument unspecified (fpga part)"
  exit -1
}

if { $argc > 4 } {
  set board_name [lindex $argv 4]
} else {
  puts "### ERROR: 5th argument unspecified (board name)"
  exit -1
}

if { $argc > 5 } {
  set simu [lindex $argv 5]
} else {
  set simu 0
}

if { $argc > 6 } {
  set options_file [lindex $argv 6]
} else {
}

source script/vivado/import_sources.tcl

unset build_dir
