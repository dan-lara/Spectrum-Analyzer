# FPGA IMPLEMENTATION DIRECTIVES
SYNTHESIS_DIRECTIVE  = Default
OPT_DESIGN_DIRECTIVE = Default
PLACEMENT_DIRECTIVE  = Default
ROUTE_DIRECTIVE      = Default

# CONSTRAINTS
PRE_SYNTH_CONSTRAINTS      =
POST_SYNTH_CONSTRAINTS     =
PROBES_CONSTRAINTS         = ${PROJECT_DIR}/xilinx_kria/constrs/pre-opt-probes.xdc
PRE_OPT_CONSTRAINTS        = ${PROJECT_DIR}/xilinx_kria/constrs/pre-opt-pinout.xdc
POST_OPT_CONSTRAINTS       = ${PROJECT_DIR}/xilinx_kria/constrs/post-opt-power_opt.tcl
PRE_PLACEMENT_CONSTRAINTS  =
POST_PLACEMENT_CONSTRAINTS = ${PROJECT_DIR}/xilinx_kria/constrs/post-placement-phys_opt.tcl
PRE_ROUTE_CONSTRAINTS      =
POST_ROUTE_CONSTRAINTS     = ${PROJECT_DIR}/xilinx_kria/constrs/post-route-phys_opt.tcl
PRE_BITSTREAM_CONSTRAINTS  =

# module include
include rtl/simple_axis_adder/sources.mk

# top synthetizable sources
SYNTH_SRC += ${PROJECT_DIR}/xilinx_kria/synth/design_1.bd
SYNTH_SRC += ${PROJECT_DIR}/xilinx_kria/synth/spectrum_analyzer_top.vhd

# top simulation sources
SIM_SRC += ${PROJECT_DIR}/xilinx_kria/sim/tb_design_1.sv
SIM_SRC += ${PROJECT_DIR}/xilinx_kria/sim/tb_spectrum_analyzer_top.sv

# testbench modules
SIM_TB += tb_design_1
SIM_TB += tb_spectrum_analyzer_top

# top design
TOP      = spectrum_analyzer_top
SIM_TOP ?= tb_spectrum_analyzer_top

