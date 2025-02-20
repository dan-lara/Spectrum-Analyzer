if { $argc > 0 } {
  set build_dir [lindex $argv 0]
} else {
  puts "### ERROR: 1st argument unspecified (build_dir)"
  exit -1
}

if { $argc > 1 } {
  if { [lindex $argv 1] == "zynq" } {
    puts "### INFO: GENERATING software platform for Zynq-7000"
    set cpu ps7_cortexa9_0
  } else {
    puts "### INFO: GENERATING software platform for ZynqMP-Soc"
    set cpu psu_cortexa53_0
  }
} else {
  puts "### WARNING: Unspecified second argument (Zynq family)"
  puts "### INFO: GENERATING software platform for ZynqMP-Soc"
  set cpu psu_cortexa53_0
}

set hwdef $build_dir/vivado/system.xsa

setws -switch $build_dir/xsct/freertos_workspace
platform create -name pfm_freertos -desc "FreeRTOS platform" -hw $hwdef -os {freertos10_xilinx} -proc $cpu

platform write
platform generate

unset hwdef
unset cpu
unset build_dir
