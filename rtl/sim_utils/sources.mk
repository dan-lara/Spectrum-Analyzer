ifndef (${sim_utils_INCLUDED})
	sim_utils_INCLUDED = 1
	sim_utils_DIR      = ${PWD}/rtl/sim_utils

  sim_utils_SIM_SRC += ${sim_utils_DIR}/sim/string_format_pkg.vhd

  SIM_SRC += ${sim_utils_SIM_SRC}

  RTL_MODULES_DEF += ${sim_utils_DIR}/sources.mk
  RTL_MODULES     += sim_utils
endif
