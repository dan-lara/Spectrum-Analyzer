if { $argc > 0 } {
  set build_dir [lindex $argv 0]
} else {
  puts "### ERROR: 1st argument unspecified (build_dir)"
  exit -1
}

source $build_dir/vivado/script/import_synth.tcl
write_hw_platform -fixed -force -force $build_dir/vivado/system.xsa
