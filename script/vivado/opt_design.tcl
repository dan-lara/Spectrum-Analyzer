if { $argc > 0 } {
  set build_dir [lindex $argv 0]
} else {
  puts "### ERROR: 1st argument unspecified (build_dir)"
  exit -1
}

if { $argc > 1 } {
  set fpga_part [lindex $argv 1]
} else {
  puts "### ERROR: 2nd argument unspecified (fpga part)"
  exit -1
}

if { $argc > 2 } {
  set directive [lindex $argv 2]
} else {
  puts "### WARNING: 3rd argument (opt_design directive) not specified: setting it to default"
  set directive "default"
}

set_property part $fpga_part [current_project]

source $build_dir/script/opt_constraints.tcl
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

opt_design -directive $directive

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

report_timing_summary -file $build_dir/opt_out/timing.rpt
report_power          -file $build_dir/opt_out/power.rpt
report_utilization    -file $build_dir/opt_out/utilization.rpt
report_drc            -file $build_dir/opt_out/drc.rpt
write_verilog -force  -file $build_dir/opt_out/netlist.v
write_xdc     -force  -file $build_dir/opt_out/bft.xdc


write_checkpoint -force -file $build_dir/dcp/opt.dcp

unset directive
unset fpga_part
unset build_dir

exit
