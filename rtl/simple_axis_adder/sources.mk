ifndef (${simple_axis_adder_INCLUDED})

  include rtl/sim_utils/sources.mk

  simple_axis_adder_INCLUDED = 1
  simple_axis_adder_DIR      = ${PWD}/rtl/simple_axis_adder

  simple_axis_adder_SYNTH_SRC += ${simple_axis_adder_DIR}/synth/simple_axis_adder.vhd
  simple_axis_adder_SYNTH_SRC += ${simple_axis_adder_DIR}/synth/simple_axis_adder_pkg.vhd

  simple_axis_adder_SIM_SRC   += ${simple_axis_adder_DIR}/sim/tb_simple_axis_adder.vhd
	simple_axis_adder_SIM_TB    += tb_simple_axis_adder

  SYNTH_SRC += ${simple_axis_adder_SYNTH_SRC}
  SIM_SRC   += ${simple_axis_adder_SIM_SRC}

  SIM_TB    += ${simple_axis_adder_SIM_TB}

  RTL_MODULES_DEF += ${simple_axis_adder_DIR}/sources.mk
  RTL_MODULES     += simple_axis_adder
endif

