source script/vivado/board/$board_name.tcl

source $build_dir/script/synth_sources.tcl
set nsources [llength $synth_list]

set ncprop [llength $common_properties]
set niprop [llength $ip_properties]
set nbprop [llength $bd_properties]

for {set i 0} {$i < $nsources} {incr i} {
  set fp [lindex $synth_list $i]
  set ext [file extension $fp]
  set fc [file rootname [file tail $fp]]
  if {$ext == ".v"} {
    read_verilog $fp
  } elseif {$ext == ".sv"} {
    read_verilog -sv $fp
  } elseif {$ext == ".vhd"} {
    read_vhdl $fp
  } elseif {$ext == ".vhdl"} {
    read_vhdl $vhdl_flags $fp
  } elseif {$ext == ".xci"} {
    read_ip $fp
    for { set j 0 } { $j < $ncprop } { incr j } {
      set prop [lindex $common_properties $j]
      set_property [dict get $prop name] [dict get $prop value] [current_project]
      unset prop
    }
    for { set j 0 } { $j < $niprop } { incr j } {
      set prop [lindex $ip_properties $j]
      set_property [dict get $prop name] [dict get $prop value] [current_project]
      unset prop
    }
    set_property target_language $preferred_language [current_project]
    generate_target all [get_files $fp]
    export_ip_user_files -of_object [get_files $fp] -no_script -force
#    export_simulation -directory ${build_dir}/build -of_object [get_files $fp] -simulator xsim -force
    update_ip_catalog
  } elseif { $ext == ".bd" } {
    read_bd $fp
		set_property target_language     $preferred_language [current_project]
    for { set j 0 } { $j < $ncprop } { incr j } {
      set prop [lindex $common_properties $j]
      set_property [dict get $prop name] [dict get $prop value] [current_project]
      unset prop
    }
    for { set j 0 } { $j < $nbprop } { incr j } {
      set prop [lindex $bd_properties $j]
      set_property [dict get $prop name] [dict get $prop value] [current_project]
      unset prop
    }
    if { $simu == 1 } {
      puts "simu is set!!!!"
      open_bd_design $fp
      set_property SELECTED_SIM_MODEL $preferred_simulation_type [get_bd_cells $cpu_regex]
      validate_bd_design
      save_bd_design
      close_bd_design [current_bd_design]
    }
    generate_target all [get_files $fp]
    export_ip_user_files -of_object [get_files $fp] -no_script -force
    export_simulation -directory ${build_dir}/build -of_object [get_files $fp] -simulator xsim -force
    make_wrapper -files [get_files $fp] -top
    if { $preferred_language == "VHDL" } {
      read_vhdl $build_dir/build/hdl/${fc}_wrapper.vhd
    } else {
      read_verilog $build_dir/build/hdl/${fc}_wrapper.v
    }
  } else {
    puts "### WARNING: Unsupported extension $ext (file:$fp): ignoring this file"
  }
  unset fc
  unset fp
  unset ext
}
