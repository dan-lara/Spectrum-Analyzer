# Copyright 2021 Raphaël Bresson

SIM_SCRIPT=$(shell find ${BUILD_DIR}/xsim/build/build/xsim/ -name *.sh)
DESIGN_NAME = $(notdir $(basename ${SIM_SCRIPT}))
SIM_ELAB_OPT = $(shell grep "xelab --incr" ${SIM_SCRIPT} | sed 's/xelab //g' \
                                                          | sed 's/-log elaborate.log//g' \
                                                          | sed 's/${DESIGN_NAME}/${SIM_TOP}/g')
SIM_VHDL_OPT=$(shell grep "xvhdl_opts=" ${SIM_SCRIPT} | sed 's/xvhdl_opts=//g' | sed 's/\"//g') --work xil_defaultlib
SIM_VLOG_OPT=$(shell grep "xvlog_opts=" ${SIM_SCRIPT} | sed 's/xvlog_opts=//g' | sed 's/\"//g') --work xil_defaultlib ${GENERATED_IPSHARED_INCLUDE}

SIM_FILES   = $(shell echo ${SIM_SRC} | tr ' ' '\n')
SYNTH_FILES = $(shell echo ${SYNTH_SRC} | tr ' ' '\n')

SIM_VHDL_FILES           = $(shell echo ${SIM_SRC} | tr ' ' '\n' | grep ".vhd")
SYNTH_VERILOG_FILES      = $(shell echo ${SIM_SRC} | tr ' ' '\n' | grep -v ".vhd" | grep -v ".vhdl" | grep -v ".sv" | grep -v ".bd" | grep -v ".xci")
SIM_SYSTEM_VERILOG_FILES = $(shell echo ${SIM_SRC} | tr ' ' '\n' | grep ".sv")

SYNTH_VHDL_FILES           = $(shell echo ${SYNTH_FILES} | tr ' ' '\n' | grep ".vhd")
SYNTH_VERILOG_FILES        = $(shell echo ${SYNTH_FILES} | tr ' ' '\n' | grep -v ".vhd" | grep -v ".vhdl" | grep -v ".sv" | grep -v ".bd" | grep -v ".xci")
SYNTH_SYSTEM_VERILOG_FILES = $(shell echo ${SYNTH_FILES} | tr ' ' '\n' | grep ".sv")

${BUILD_DIR}/xsim/import-synth.done: ${BUILD_DIR}/vivado/script/synth_sources.tcl
	@echo "----------------------------------------------------------------"
	@echo "---     RTL SIMULATION SYNTHETIZABLE FILES IMPORTATION       ---"
	@echo "----------------------------------------------------------------"
	@rm -rf ${BUILD_DIR}/xsim/sim
	@vivado -mode batch -source script/vivado/import_synth.tcl -notrace -nojournal -nolog -tclargs "${BUILD_DIR}/xsim" "Verilog" "rtl" "${PART}" "${BOARD_NAME}" 1
	@echo "DONE" > ${BUILD_DIR}/xsim/import-synth.done

${BUILD_DIR}/xsim/${SIM_TOP}-compile.done: ${BUILD_DIR}/xsim/import-synth.done ${SIM_SRC}
	@echo "----------------------------------------------------------------"
	@echo "---          RTL SIMULATION: FILES COMPILATION               ---"
	@echo "----------------------------------------------------------------"
	@mkdir -p ${BUILD_DIR}/xsim/log
	@if [ -f "${BUILD_DIR}/xsim/build/build/xsim/vhdl.prj" ]; then \
	  cd ${BUILD_DIR}/xsim/build/build/xsim && xvhdl ${SIM_VHDL_OPT} -prj ${BUILD_DIR}/xsim/build/build/xsim/vhdl.prj -log ${BUILD_DIR}/xsim/log/xvhdl.log; \
	fi
	@if [ -f "${BUILD_DIR}/xsim/build/build/xsim/vlog.prj" ]; then \
	  cd ${BUILD_DIR}/xsim/build/build/xsim && xvlog ${SIM_VLOG_OPT} -prj ${BUILD_DIR}/xsim/build/build/xsim/vlog.prj -log ${BUILD_DIR}/xsim/log/xvlog.log; \
	fi
	@bd_wrapper_verilog=`find ${BUILD_DIR}/xsim/build/hdl -name *.v`; \
	cd ${BUILD_DIR}/xsim/build/build/xsim && xvlog ${SIM_VLOG_OPT} $${bd_wrapper_verilog} ${SYNTH_VERILOG_FILES} ${SIM_VERILOG_FILES} -log ${BUILD_DIR}/xsim/log/verilog.log; \
	if [[ "${SIM_SYSTEM_VERILOG_FILES} ${SYNTH_SYSTEM_VERILOG_FILES}" == *[!\ ]* ]]; then \
		cd ${BUILD_DIR}/xsim/build/build/xsim && xvlog -sv ${SIM_VLOG_OPT} ${SYNTH_SYSTEM_VERILOG_FILES} ${SIM_SYSTEM_VERILOG_FILES} -log ${BUILD_DIR}/xsim/log/systemverilog.log; \
	fi; \
	if [[ "${SIM_VHDL_FILES} ${SYNTH_VHDL_FILES}" == *[!\ ]* ]]; then \
		cd ${BUILD_DIR}/xsim/build/build/xsim && xvhdl ${SIM_VHDL_OPT} ${SYNTH_VHDL_FILES} ${SIM_VHDL_FILES} -log ${BUILD_DIR}/xsim/log/vhdl.log; \
	fi
	echo "done" > $@

${BUILD_DIR}/xsim/${SIM_TOP}-elab.done: ${BUILD_DIR}/xsim/${SIM_TOP}-compile.done
	@echo "----------------------------------------------------------------"
	@echo "---              RTL SIMULATION ELABORATION                  ---"
	@echo "----------------------------------------------------------------"
	@cd ${BUILD_DIR}/xsim/build/build/xsim && xelab ${SIM_ELAB_OPT} -log ${BUILD_DIR}/xsim/log/elab.log
	echo "done" > $@

.PHONY: sim
sim: ${BUILD_DIR}/xsim/${SIM_TOP}-elab.done
	@echo "----------------------------------------------------------------"
	@echo "---              RTL SIMULATION LAUNCHING XSIM               ---"
	@echo "----------------------------------------------------------------"
	@echo "### INFO: top level module: ${SIM_TOP}"
	@echo "### INFO: Generating tcl script build/xsim/script/xsim.tcl"
	@echo "log_wave -r *" > ${BUILD_DIR}/xsim/script/xsim.tcl
	@if [ "${SIM_MODE}" == "gui" ]; then \
		cd ${BUILD_DIR}/xsim/build/build/xsim && xsim ${SIM_TOP} ${PROTOINST_DECLARE} -tclbatch ${BUILD_DIR}/xsim/script/xsim.tcl -gui -log ${BUILD_DIR}/xsim/log/xsim.log -wdb ${BUILD_DIR}/xsim/${SIM_TOP}.wdb; \
	else \
		cd ${BUILD_DIR}/xsim/build/build/xsim && xsim ${SIM_TOP} ${PROTOINST_DECLARE} -R -log ${BUILD_DIR}/xsim/log/xsim.log; \
	fi;

.PHONY: sim-clean
sim-clean:
	@echo "### INFO: Cleaning simulation outputs"
	@rm -rf build/xsim xsim.dir *.pb *.log *.dir *.jou *.wdb
