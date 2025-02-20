source script/vivado/board/$board_name.tcl
# stage = 0: synth
# stage = 1: opt_design
# stage = 2: placement
# stage = 3: route
# stage = 4: bitstream
if { stage == 0 } {
  source $build_dir/script/synth_constraints.tcl
} elseif { stage == 1 } {
  source $build_dir/script/opt_constraints.tcl
} elseif { stage == 2 } {
  source $build_dir/script/placement_constraints.tcl
} elseif { stage == 3 } {
  source $build_dir/script/route_constraints.tcl
} elseif { stage == 4 } {
  source $build_dir/script/bitstream_constraints.tcl
}
set pre_sources [llength $pre_constrs_list]
set post_sources [llength $post_constrs_list]

if { state == 0 } {
  for {set i 0} {$i < $pre_sources} {incr i} {
    set fp [lindex $synth_list $i]
    set ext [file extension $fp]
    set fc [file rootname [file tail $fp]]
    if {$ext == ".xdc"} {
      read_xdc $fp
    } elseif {$ext == ".tcl"} {
      source $fp
    }
  }
} else {
  for {set i 0} {$i < $post_sources} {incr i} {
    set fp [lindex $synth_list $i]
    set ext [file extension $fp]
    set fc [file rootname [file tail $fp]]
    if {$ext == ".xdc"} {
      read_xdc $fp
    } elseif {$ext == ".tcl"} {
      source $fp
    }
  }
}
