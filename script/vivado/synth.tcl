if { $argc > 0 } {
  set build_dir [lindex $argv 0]
} else {
  puts "### ERROR: 1st argument unspecified (build_dir)"
  exit -1
}

if { $argc > 1 } {
  set top_module [lindex $argv 1]
} else {
  puts "### ERROR: 2nd argument unspecified (top module)"
  exit -1
}

if { $argc > 2 } {
  set fpga_part [lindex $argv 2]
} else {
  puts "### ERROR: 3rd argument unspecified (fpga part)"
  exit -1
}

if { $argc > 3 } {
  set board_name [lindex $argv 3]
} else {
  puts "### ERROR: 4th argument unspecified (board name)"
  exit -1
}

if { $argc > 4 } {
  set directive [lindex $argv 4]
} else {
  puts "### WARNING: 5th argument unspecified (synthesis directive): setting it to default"
  set directive "default"
}

if { $argc > 5 } {
  set preferred_language [lindex $argv 5]
} else {
  puts "### WARNING: 6th argument unspecified (preferred language): setting it to default: VHDL"
  set preferred_language "VHDL"
}

if { $argc > 6 } {
  set options_file [lindex $argv 6]
} else {
}

set preferred_simulation_type "rtl"
set simu 0

source script/vivado/import_sources.tcl
source $build_dir/script/synth_constraints.tcl
set pre_sources [llength $pre_constrs_list]
set post_sources [llength $post_constrs_list]

for {set i 0} {$i < $pre_sources} {incr i} {
  set fp [lindex $pre_constrs_list $i]
  set ext [file extension $fp]
  set fc [file rootname [file tail $fp]]
  if {$ext == ".xdc"} {
    read_xdc $fp
  } elseif {$ext == ".tcl"} {
    source $fp
  }
}

synth_design -top $top_module -part $fpga_part -directive $directive

for {set i 0} {$i < $post_sources} {incr i} {
  set fp [lindex $post_constrs_list $i]
  set ext [file extension $fp]
  set fc [file rootname [file tail $fp]]
  if {$ext == ".xdc"} {
    read_xdc $fp
  } elseif {$ext == ".tcl"} {
    source $fp
  }
}

report_timing_summary -file $build_dir/synth_out/timing.rpt
report_power          -file $build_dir/synth_out/power.rpt
report_utilization    -file $build_dir/synth_out/utilization.rpt
report_drc            -file $build_dir/synth_out/drc.rpt
write_verilog -force  -file $build_dir/synth_out/netlist.v
write_xdc     -force  -file $build_dir/synth_out/bft.xdc

write_checkpoint -force -file $build_dir/dcp/synth.dcp

unset directive
unset fpga_part
unset top_module
unset build_dir

exit
