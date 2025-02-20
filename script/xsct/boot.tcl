if {$argc > 0} {
  set build_dir [lindex $argv 0]
} else {
  puts "### ERROR: Argument not specified (build_dir)"
  exit -1
}

puts "### INFO: Build dir is: $build_dir"

if {$argc > 1} {
  set family [lindex $argv 1]
} else {
  set family "zynqmp"
}

puts "### INFO: SoC family is: $family"

if {$argc > 2} {
  set bootmode [lindex $argv 2]
} else {
  set bootmode "linux"
}

puts "### INFO: Bootmode is: $bootmode"

if {$bootmode == "baremetal"} {
  if {$argc > 3} {
    set elf [lindex $argv 3]
    puts "### INFO: Baremetal application is: $elf"
  } else {
    puts "### ERROR: Missing third argument (baremetal_elf) to boot baremetal application"
    exit -1
  }
  if {$argc > 4} {
    set dbg [lindex $argv 4]
  } else {
    set dbg 0
  }
  if {$argc > 5} {
    set nverbose [lindex $argv 5]
  } else {
    set nverbose 0
  }
} elseif {$bootmode == "freertos"} {
  if {$argc > 3} {
    set elf [lindex $argv 3]
    puts "### INFO: FreeRTOS application is: $elf"
  } else {
    puts "### ERROR: Missing third argument (freertos_elf) to boot FreeRTOS application"
    exit -1
  }
  if {$argc > 4} {
    set dbg [lindex $argv 4]
  } else {
    set dbg 0
  }
  if {$argc > 5} {
    set nverbose [lindex $argv 5]
  } else {
    set nverbose 0
  }
} else {
  if {$argc > 3} {
    set nverbose [lindex $argv 3]
  } else {
    set nverbose 0
  }
}

if {$family == "zynq"} {
  set init_script $build_dir/vivado/ps7_init.tcl
} else {
  set init_script $build_dir/vivado/psu_init.tcl
}

if {$nverbose == 0} {
  puts "### INFO: VERBOSE OUTPUTS ARE ENABLED"
} else {
  puts "### INFO: VERBOSE OUTPUTS ARE DISABLED"
}

source $init_script
unset init_script

proc zynq7_boot_linux {build_dir nverbose} {
  set fsbl      $build_dir/xsct/fsbl/executable.elf
  set uboot     $build_dir/buildroot-output/images/u-boot.elf
  set kernel    $build_dir/buildroot-output/images/uImage
  set dtb       $build_dir/buildroot-output/images/system-top.dtb
  set scr       $build_dir/buildroot-output/images/boot_jtag.scr
  set initramfs $build_dir/buildroot-output/images/rootfs.cpio.uboot
  set bitstream $build_dir/vivado/bitstream.bit
	configparams silent-mode $nverbose
  if { [catch {connect} ] != 0} {
    puts "### ERROR: Connection to hardware server failed"
    exit -1
  }
	targets -set -nocase -filter {name =~ "*ARM* #0"}
  puts "### INFO: Resetting system"
  rst
  puts "### INFO: Initialize APU"
  ps7_init
  ps7_post_config
  puts "### INFO: Programming FPGA bitstream ($bitstream)"
  fpga $bitstream
  puts "### INFO: Downloading uboot script at 0x03000000 ($scr)"
  dow -data $scr    0x03000000
  puts "### INFO: Downloading u-boot elf ($uboot)"
  dow $uboot
  puts "### INFO: Downloading Kernel at 0x02080000 ($kernel)"
  dow -data $kernel    0x02080000
  puts "### INFO: Downloading device tree blob at 0x02000000 ($dtb)"
  dow -data $dtb       0x02000000
  puts "### INFO: Downloading initramfs at 0x08000000 ($initramfs)"
  dow -data $initramfs 0x08000000
  con
}

proc zynq7_boot_baremetal {build_dir elf dbg nverbose} {
  set bitstream $build_dir/vivado/bitstream.bit
	configparams silent-mode $nverbose
  if { [catch {connect} ] != 0} {
    puts "### ERROR: Connection to hardware server failed"
    exit -1
  }
	targets -set -nocase -filter {name =~ "*ARM* #0"}
  puts "### INFO: Resetting system"
  rst
  puts "### INFO: Initialize APU"
  ps7_init
  ps7_post_config
  puts "### INFO: Programming FPGA bitstream ($bitstream)"
  fpga $bitstream
  dow $elf
	bpadd -addr &main
	con -block -timeout 50
  if { $dbg == 0 } {
    con
    puts "### INFO: Application $elf started"
  } else {
    puts "### INFO: Application $elf started (debug mode)"
  }
}

proc zynqmp_boot_linux {build_dir nverbose} {
  set fsbl      $build_dir/xsct/fsbl/executable.elf
  set pmufw     $build_dir/xsct/pmufw/executable.elf
  set dtb       $build_dir/buildroot-output/images/system-top.dtb
  set uboot     $build_dir/buildroot-output/images/u-boot.elf
  set bl31      $build_dir/buildroot-output/images/bl31.elf
  set scr       $build_dir/buildroot-output/images/boot_jtag.scr
  set kernel    $build_dir/buildroot-output/images/Image.lzma
  set initramfs $build_dir/buildroot-output/images/rootfs.cpio.uboot
  set bitstream $build_dir/vivado/bitstream.bit
	configparams silent-mode $nverbose
  if { [catch {connect} ] != 0} {
    puts "### ERROR: Connection to hardware server failed"
    exit -1
  }
	targets -set -nocase -filter {name =~ "*PSU*"}
	puts "### INFO: Updating multiboot to zero"
  mwr 0xffca0010 0x0
  set mode [expr [mrd -value 0xFF5E0200] & 0xf]
  puts "### INFO: Current boot mode is $mode"
	puts "### INFO: Changing boot mode to JTAG (0)"
  mwr 0xFF5E0200 0x100
  puts "### INFO: Resetting system"
  rst -system
  after 500
  puts "### INFO: Disabling security gates for APU, PS TAP and PMU"
  mwr 0xFFCA0038 0x1FF
  puts "### INFO: Programming FPGA bitstream ($bitstream)"
  targets -set -nocase -filter {name =~ "*PS TAP*"}
  fpga $bitstream
  puts "### INFO: Programming firmware of MicroBlaze PMU ($pmufw)"
	targets -set -nocase -filter {name =~ "*MicroBlaze PMU*"}
  dow $pmufw
  con
  puts "### INFO: Configuring APU"
  targets -set -nocase -filter {name =~ "*APU*"}
  mwr 0xFFFF0000 0x14000000
  mask_write 0xFD1A0104 0x501 0x0
	configparams force-mem-access 1
  puts "### INFO: Resetting core 0"
  targets -set -nocase -filter {name =~ "*Cortex-A53* #0"}
	rst -processor
  after 500
  puts "### INFO: Running FSBL on core 0 ($fsbl)"
  dow $fsbl
  set bp_fsblend [bpadd -addr &XFsbl_Exit]
  con -block -timeout 50
  bpremove $bp_fsblend
  catch {stop}
  psu_init
  psu_ps_pl_isolation_removal
  after 500
  psu_ps_pl_reset_config
  catch {psu_protection}
  puts "### INFO: Downloading uboot script at 0x20000000 ($scr)"
  dow -data $scr 0x20000000
  puts "### INFO: Downloading device tree blob at 0x40000000 ($dtb)"
  dow -data $dtb 0x40000000
  puts "### INFO: Downloading u-boot elf ($uboot)"
  dow $uboot
  puts "### INFO: Downloading Arm Trusted Firmware ($bl31)"
  dow $bl31
  puts "### INFO: Downloading Kernel at 0x18000000 ($kernel)"
  dow -data $kernel 0x18000000
  puts "### INFO: Downloading initramfs at 0x02100000 ($initramfs)"
  dow -data $initramfs 0x02100000
  con
  puts "### INFO: Re-enable protection barrier"
  targets -set -nocase -filter {name =~ "*APU*"}
	configparams force-mem-access 0
}

proc zynqmp_boot_baremetal {build_dir elf dbg nverbose} {
  set pmufw     $build_dir/xsct/pmufw/executable.elf
  set bitstream $build_dir/vivado/bitstream.bit
	configparams silent-mode 0
  if { [catch {connect} ] != 0} {
    puts "### ERROR: Connection to hardware server failed"
    exit -1
  }
	targets -set -nocase -filter {name =~ "*PSU*"}
	puts "### INFO: Updating multiboot to zero"
  mwr 0xffca0010 0x0
  set mode [expr [mrd -value 0xFF5E0200] & 0xf]
  puts "### INFO: Current boot mode is $mode"
	puts "### INFO: Forcing boot mode to JTAG (0)"
  mwr 0xFF5E0200 0x100
  puts "### INFO: Resetting system"
  rst -system
  after 500
  puts "### INFO: Disabling security gates for APU, PS TAP and PMU"
  mwr 0xFFCA0038 0x1FF
  puts "### INFO: Programming FPGA bitstream ($bitstream)"
  targets -set -nocase -filter {name =~ "*PS TAP*"}
  fpga $bitstream
  puts "### INFO: Programming firmware of MicroBlaze PMU ($pmufw)"
	targets -set -nocase -filter {name =~ "*MicroBlaze PMU*"}
  dow $pmufw
  con
  puts "### INFO: Configuring APU"
  targets -set -nocase -filter {name =~ "*APU*"}
	configparams force-mem-access 1
  mwr 0xFFFF0000 0x14000000
  mask_write 0xFD1A0104 0x501 0x0
  psu_init
  psu_ps_pl_isolation_removal
  after 500
  psu_ps_pl_reset_config
  catch {psu_protection}
  targets -set -nocase -filter {name =~ "*Cortex-A53* #0"}
  dow $elf
	bpadd -addr &main
	con -block -timeout 50
  if { $dbg == 0 } {
    con
    puts "### INFO: Application $elf started"
  }
}

if {$family == "zynq"} {
  if {$bootmode == "linux"} {
    zynq7_boot_linux $build_dir $nverbose
  } else {
    zynq7_boot_baremetal $build_dir $elf $dbg $nverbose
    unset elf
    unset dbg
  }
} else {
  if {$bootmode == "linux"} {
    zynqmp_boot_linux $build_dir $nverbose
  } else {
    zynqmp_boot_baremetal $build_dir $elf $dbg $nverbose
    unset elf
    unset dbg
  }
}

unset build_dir
unset family
unset nverbose
unset bootmode
