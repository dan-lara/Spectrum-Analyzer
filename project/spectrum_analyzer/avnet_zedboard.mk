# FPGA IMPLEMENTATION DIRECTIVES
SYNTHESIS_DIRECTIVE  = Default
OPT_DESIGN_DIRECTIVE = Default
PLACEMENT_DIRECTIVE  = Default
ROUTE_DIRECTIVE      = Default

# CONSTRAINTS
PRE_SYNTH_CONSTRAINTS      =
POST_SYNTH_CONSTRAINTS     =
PROBES_CONSTRAINTS         = ${PROJECT_DIR}/avnet_zedboard/constrs/pre-opt-probes.xdc
PRE_OPT_CONSTRAINTS        = ${PROJECT_DIR}/avnet_zedboard/constrs/pre-opt-pinout.xdc
POST_OPT_CONSTRAINTS       = ${PROJECT_DIR}/avnet_zedboard/constrs/post-opt-power_opt.tcl
PRE_PLACEMENT_CONSTRAINTS  =
POST_PLACEMENT_CONSTRAINTS = ${PROJECT_DIR}/avnet_zedboard/constrs/post-placement-phys_opt.tcl
PRE_ROUTE_CONSTRAINTS      =
POST_ROUTE_CONSTRAINTS     = ${PROJECT_DIR}/avnet_zedboard/constrs/post-route-phys_opt.tcl
PRE_BITSTREAM_CONSTRAINTS  =

# module include
include rtl/led_blink/sources.mk
include rtl/simple_axis_adder/sources.mk
include rtl/vga/sources.mk
include rtl/i2s/sources.mk

# top synthetizable sources
SYNTH_SRC += ${PROJECT_DIR}/avnet_zedboard/synth/design_1.bd
SYNTH_SRC += ${PROJECT_DIR}/avnet_zedboard/synth/spectrum_analyzer_top.vhd

# top simulation sources
SIM_SRC   += ${PROJECT_DIR}/avnet_zedboard/sim/tb_design_1.sv
SIM_SRC   += ${PROJECT_DIR}/avnet_zedboard/sim/tb_spectrum_analyzer_top.sv

# testbench modules
SIM_TB += tb_design_1
SIM_TB += tb_spectrum_analyzer_top

# top design
TOP      = spectrum_analyzer_top
SIM_TOP ?= tb_spectrum_analyzer_top
