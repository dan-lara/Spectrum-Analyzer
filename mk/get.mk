# Copyright 2021 Raphaël Bresson

# SYNTH TOP MODULE
.PHONY: get-rtl-top
get-rtl-top:
	@echo "${TOP}"

# SIMULATION TOP RTL TESTBENCH
.PHONY: get-sim-top
get-sim-top:
	@echo "${SIM_TOP}"

# RTL IMPORTED MODULES
.PHONY: get-rtl-modules
get-rtl-modules:
	@echo "${RTL_MODULES}"

# RTL IMPORTED MODULES DEFINITION FILES
.PHONY: get-rtl-modules-def
get-rtl-modules-def:
	@echo "${RTL_MODULES_DEF}"

# SYNTH SOURCES
.PHONY: get-synth-sources
get-synth-sources:
	@echo "${SYNTH_SRC}"

# SIMULATION RTL TESTBENCHES
.PHONY: get-sim-testbenches
get-sim-testbenches:
	@echo "${SIM_TB}"

# SIMULATION RTL SOURCES
.PHONY: get-sim-sources
get-sim-sources:
	@echo "${SIM_SRC}"

# PROBES CONSTRAINTS
.PHONY: get-probes-constraints
get-probes-constraints:
	@echo "${PROBES_CONSTRAINTS}"

# PRE SYNTHESIS CONSTRAINTS
.PHONY: get-pre-synth-constraints
get-pre-synth-constraints:
	@echo "${PRE_SYNTH_CONSTRAINTS}"

# POST SYNTHESIS CONSTRAINTS
.PHONY: get-post-synth-constraints
get-post-synth-constraints:
	@echo "${POST_SYNTH_CONSTRAINTS}"

# PRE OPT CONSTRAINTS
.PHONY: get-pre-opt-constraints
get-pre-opt-constraints:
	@echo "${PRE_OPT_CONSTRAINTS}"

# POST OPT CONSTRAINTS
.PHONY: get-post-opt-constraints
get-post-opt-constraints:
	@echo "${POST_OPT_CONSTRAINTS}"

# PRE PLACEMENT CONSTRAINTS
.PHONY: get-pre-placement-constraints
get-pre-placement-constraints:
	@echo "${PRE_PLACEMENT_CONSTRAINTS}"

# POST PLACEMENT CONSTRAINTS
.PHONY: get-post-placement-constraints
get-post-placement-constraints:
	@echo "${POST_PLACEMENT_CONSTRAINTS}"

# PRE ROUTE CONSTRAINTS
.PHONY: get-pre-route-constraints
get-pre-route-constraints:
	@echo "${PRE_ROUTE_CONSTRAINTS}"

# POST ROUTE CONSTRAINTS
.PHONY: get-post-route-constraints
get-post-route-constraints:
	@echo "${POST_ROUTE_CONSTRAINTS}"

# PRE BITSTREAM
.PHONY: get-pre-bitstream-constraints
get-pre-bitstream-constraints:
	@echo "${PRE_BITSTREAM_CONSTRAINTS}"

