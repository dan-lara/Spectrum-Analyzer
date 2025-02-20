GHDL_SIM_FILES   += $(shell echo ${SIM_SRC} | tr ' ' '\n' | grep ".vhd")
GHDL_SYNTH_FILES += $(shell echo ${SYNTH_SRC} | tr ' ' '\n' | grep ".vhd")
GHDL_FLAGS       += --std=08

${BUILD_DIR}/ghdl:
	mkdir ${BUILD_DIR}/ghdl

${BUILD_DIR}/ghdl/work-obj08.cf: ${GHDL_SIM_FILES} ${GHDL_SYNTH_FILES}
	cd ${BUILD_DIR}/ghdl && ghdl -i ${GHDL_SIM_FILES} ${GHDL_SYNTH_FILES}

${BUILD_DIR}/ghdl/${GHDL_SIM_TOP}: ${BUILD_DIR}/ghdl/work.cf
	cd ${BUILD_DIR}/ghdl && ghdl -m ${GHDL_SIM_TOP}

.PHONY: ghdl-sim
ghdl-sim: ${BUILD_DIR}/ghdl/${GHDL_SIM_TOP}
	cd ${BUILD_DIR}/ghdl && ghdl -r ${GHDL_SIM_TOP} --wave=${GHDL_SIM_TOP}.ghw

