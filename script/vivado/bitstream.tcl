if { $argc > 0 } {
  set build_dir [lindex $argv 0]
} else {
  puts "### ERROR: 1st argument unspecified (build_dir)"
  exit -1
}

if { $argc > 1 } {
  set use_probes [lindex $argv 1]
} else {
  set use_probes "NO"
}
source $build_dir/script/bitstream_constraints.tcl
set pre_sources [llength $pre_constrs_list]

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

write_bitstream -force $build_dir/bitstream.bit
write_hw_platform -fixed -include_bit -force $build_dir/system.xsa
report_timing_summary -file $build_dir/bitstream_out/timing.rpt
report_power          -file $build_dir/bitstream_out/power.rpt
report_utilization    -file $build_dir/bitstream_out/utilization.rpt
report_drc            -file $build_dir/bitstream_out/drc.rpt
write_verilog -force  -file $build_dir/bitstream_out/netlist.v
write_xdc     -force  -file $build_dir/bitstream_out/bft.xdc

if {$use_probes == "YES"} {
  write_debug_probes $build_dir/probes.ltx
}

write_checkpoint -force -file $build_dir/dcp/bitstream.dcp

unset build_dir
unset use_probes

exit
