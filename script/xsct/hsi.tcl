proc usage { prog } {
  puts "usage:"
  puts "xsct -nodisp $prog build_dir \[ family \[ board \] \]"
  puts "build_dir: directory where all has to be build"
  puts "family: Soc family (Must be zynqmp or zynq7)"
  puts "board : Board name"
  puts "family default: zynqmp"
  puts "board default: zynqmp : kria"
  puts "               zynq7  : zedboard"
}

if {$argc > 0} {
  set build_dir [lindex $argv 0]
} else {
  puts "### ERROR: Missing 1st argument (build_dir)"
  usage $argv0
  exit -1
}

if {$argc > 1} {
  set family [lindex $argv 1]
} else {
  puts "### WARNING: Missing 2nd argument (family): setting to zynqmp"
  set family "zynqmp"
}

puts "### INFO: Hardware design is $build_dir/vivado/system.xsa"
hsi::open_hw_design $build_dir/vivado/system.xsa

if { $family == "zynq" } {

  if {$argc > 2} {
    set board [lindex $argv 2]
  } else {
    puts "### WARNING: Missing 3rd argument (board): setting to zedboard"
    set board "zedboard"
  }

  puts "### INFO: Creating Zynq-7000 FSBL"
  hsi::create_sw_design impl_fsbl -proc ps7_cortexa9_0 -app zynq_fsbl
  hsi::generate_app -os standalone -proc ps7_cortexa9_0 -app zynq_fsbl -compile -sw fsbl -dir $build_dir/xsct/fsbl
  hsi::close_sw_design impl_fsbl

  puts "### INFO: Creating Zynq-7000 device tree"
  hsi::set_repo_path $build_dir/xsct/device-tree-xlnx
  hsi::create_sw_design device-tree-sources -proc ps7_cortexa9_0 -os device_tree
  hsi::set_property CONFIG.periph_type_overrides "{BOARD $board}" [hsi::get_os]
  hsi::generate_bsp -dir $build_dir/xsct/dts
  hsi::close_sw_design device-tree-sources
  unset board

} elseif { $family == "zynqmp" } {

  if {$argc > 2} {
    set board [lindex $argv 2]
  } else {
    puts "### WARNING: Missing 3rd argument (board): setting to zynqmp-sm-k26-reva"
    usage
    set board "zynqmp-smk-k26-reva"
  }

  puts "### INFO: Creating ZynqMP-SoC PMUFW"
  hsi::create_sw_design impl_pmufw -proc psu_pmu_0 -app zynqmp_pmufw
  hsi::generate_app -os standalone -proc psu_pmu_0 -app zynqmp_pmufw -sw pmufw -compile -dir $build_dir/xsct/pmufw
  hsi::close_sw_design impl_pmufw

  puts "### INFO: Creating ZynqMP-SoC FSBL for ARM Cortex A53"
  hsi::create_sw_design impl_fsbl -proc psu_cortexa53_0 -app zynqmp_fsbl
  hsi::generate_app -os standalone -proc psu_cortexa53_0 -app zynqmp_fsbl -sw fsbl -compile -dir $build_dir/xsct/fsbl
  hsi::close_sw_design impl_fsbl

  puts "### INFO: Creating ZynqMP-SoC device tree"
  hsi::set_repo_path $build_dir/xsct/device-tree-xlnx
  hsi::create_sw_design device-tree-sources -proc psu_cortexa53_0 -os device_tree
  hsi::set_property CONFIG.periph_type_overrides "{BOARD $board}" [hsi::get_os]
  hsi::generate_bsp -dir $build_dir/xsct/dts
  hsi::close_sw_design device-tree-sources
  unset board

} else {
  puts "### ERROR: Not supported SoC family"
  exit -1
}

unset family
unset build_dir

