# Copyright 2021 Raphaël Bresson

${BUILD_DIR}/vivado:
	@mkdir -p $@
	@mkdir -p $@/build
	@mkdir -p $@/synth_out
	@mkdir -p $@/opt_out
	@mkdir -p $@/placement_out
	@mkdir -p $@/route_out
	@mkdir -p $@/bitstream_out
	@mkdir -p $@/dcp
	@mkdir -p $@/script
	@mkdir -p ${BUILD_DIR}/xsim
	@mkdir -p ${BUILD_DIR}/xsim/build
	@mkdir -p ${BUILD_DIR}/xsim/script
	@mkdir -p ${BUILD_DIR}/xsim/log
	@mkdir -p ${BUILD_DIR}/xsim-hw_emu
	@mkdir -p ${BUILD_DIR}/xsim-hw_emu/build
	@mkdir -p ${BUILD_DIR}/xsim-hw_emu/script
	@mkdir -p ${BUILD_DIR}/xsim-hw_emu/log
	@mkdir -p ${BUILD_DIR}/xsim-hw_emu/dts

${BUILD_DIR}/vivado/script/synth_sources.tcl: ${SYNTH_SRC} | ${BUILD_DIR}/vivado ${BUILD_DIR}/xsim
	@rm -f $@
	@rm -f ${BUILD_DIR}/vivado/script/save_sources.sh
	@rm -f ${BUILD_DIR}/vivado/script/restore_sources.sh
	@touch $@
	@touch ${BUILD_DIR}/vivado/script/save_sources.sh
	@touch ${BUILD_DIR}/vivado/script/restore_sources.sh
	@echo "set synth_list {" > $@
	@for f in ${SYNTH_SRC}; do \
	   cp $${f} ${BUILD_DIR}/vivado/build/`basename $${f}`; \
	   cp $${f} ${BUILD_DIR}/xsim/build/`basename $${f}`; \
	   cp $${f} ${BUILD_DIR}/xsim-hw_emu/build/`basename $${f}`; \
	   echo "  ${BUILD_DIR}/vivado/build/`basename $${f}`" >> $@; \
	   echo "cp ${BUILD_DIR}/vivado/build/`basename $${f}` $${f}" >> ${BUILD_DIR}/vivado/script/save_sources.sh; \
	   echo "cp $${f} ${BUILD_DIR}/vivado/build/`basename $${f}`" >> ${BUILD_DIR}/vivado/script/restore_sources.sh; \
  done
	@echo "}" >> $@
	@cp $@ ${BUILD_DIR}/xsim/script/synth_sources.tcl
	@cp $@ ${BUILD_DIR}/xsim-hw_emu/script/synth_sources.tcl
	@sed -i 's/vivado/xsim/g' ${BUILD_DIR}/xsim/script/synth_sources.tcl
	@sed -i 's/vivado/xsim-hw_emu/g' ${BUILD_DIR}/xsim-hw_emu/script/synth_sources.tcl

${BUILD_DIR}/vivado/script/synth_constraints.tcl: ${PRE_SYNTH_CONSTRAINTS} ${POST_SYNTH_CONSTRAINTS} | ${BUILD_DIR}/vivado
	@rm -f $@
	@touch $@
	@echo "set pre_constrs_list {" > $@
	@for f in ${PRE_SYNTH_CONSTRAINTS}; do \
	  cp $${f} ${BUILD_DIR}/vivado/build/`basename $${f}`; \
    echo "  ${BUILD_DIR}/vivado/build/`basename $${f}`" >> $@; \
  done
	@echo "}" >> $@
	@echo "set post_constrs_list {" >> $@
	@for f in ${POST_SYNTH_CONSTRAINTS}; do \
	  cp $${f} ${BUILD_DIR}/vivado/build/`basename $${f}`; \
    echo "  ${BUILD_DIR}/vivado/build/`basename $${f}`" >> $@; \
  done
	@echo "}" >> $@

${BUILD_DIR}/vivado/script/opt_constraints.tcl: ${PRE_OPT_CONSTRAINTS} ${POST_OPT_CONSTRAINTS} ${PROBES_CONSTRAINTS} | ${BUILD_DIR}/vivado
	@rm -f $@
	@touch $@
	@echo "set pre_constrs_list {" > $@
	@if [ "${USE_PROBES}" == "YES" ]; then \
		for f in ${PROBES_CONSTRAINTS}; do \
		  cp $${f} ${BUILD_DIR}/vivado/build/`basename $${f}`; \
			echo "  ${BUILD_DIR}/vivado/build/`basename $${f}`" >> $@; \
		done; \
	fi;
	@for f in ${PRE_OPT_CONSTRAINTS}; do \
	  cp $${f} ${BUILD_DIR}/vivado/build/`basename $${f}`; \
    echo "  ${BUILD_DIR}/vivado/build/`basename $${f}`" >> $@; \
  done
	@echo "}" >> $@
	@echo "set post_constrs_list {" >> $@
	@for f in ${POST_OPT_CONSTRAINTS}; do \
	  cp $${f} ${BUILD_DIR}/vivado/build/`basename $${f}`; \
    echo "  ${BUILD_DIR}/vivado/build/`basename $${f}`" >> $@; \
  done
	@echo "}" >> $@

${BUILD_DIR}/vivado/script/placement_constraints.tcl: ${PRE_PLACEMENT_CONSTRAINTS} ${POST_PLACEMENT_CONSTRAINTS} | ${BUILD_DIR}/vivado
	@rm -f $@
	@touch $@
	@echo "set pre_constrs_list {" > $@
	@for f in ${PRE_PLACEMENT_CONSTRAINTS}; do \
	  cp $${f} ${BUILD_DIR}/vivado/build/`basename $${f}`; \
    echo "  ${BUILD_DIR}/vivado/build/`basename $${f}`" >> $@; \
  done
	@echo "}" >> $@
	@echo "set post_constrs_list {" >> $@
	@for f in ${POST_PLACEMENT_CONSTRAINTS}; do \
	  cp $${f} ${BUILD_DIR}/vivado/build/`basename $${f}`; \
    echo "  ${BUILD_DIR}/vivado/build/`basename $${f}`" >> $@; \
  done
	@echo "}" >> $@

${BUILD_DIR}/vivado/script/route_constraints.tcl: ${PRE_ROUTE_CONSTRAINTS} ${POST_ROUTE_CONSTRAINTS} | ${BUILD_DIR}/vivado
	@rm -f $@
	@touch $@
	@echo "set pre_constrs_list {" > $@
	@for f in ${PRE_ROUTE_CONSTRAINTS}; do \
	  cp $${f} ${BUILD_DIR}/vivado/build/`basename $${f}`; \
    echo "  ${BUILD_DIR}/vivado/build/`basename $${f}`" >> $@; \
  done
	@echo "}" >> $@
	@echo "set post_constrs_list {" >> $@
	@for f in ${POST_ROUTE_CONSTRAINTS}; do \
	  cp $${f} ${BUILD_DIR}/vivado/build/`basename $${f}`; \
    echo "  ${BUILD_DIR}/vivado/build/`basename $${f}`" >> $@; \
  done
	@echo "}" >> $@

${BUILD_DIR}/vivado/script/bitstream_constraints.tcl: ${PRE_BITSTREAM_CONSTRAINTS} | ${BUILD_DIR}/vivado
	@rm -f $@
	@touch $@
	@echo "set pre_constrs_list {" > $@
	@for f in ${PRE_BITSTREAM_CONSTRAINTS}; do \
	  cp $${f} ${BUILD_DIR}/vivado/build/`basename $${f}`; \
    echo "  ${BUILD_DIR}/vivado/build/`basename $${f}`" >> $@; \
  done
	@echo "}" >> $@

${BUILD_DIR}/vivado/dcp/synth.dcp: ${BUILD_DIR}/vivado/script/synth_sources.tcl ${BUILD_DIR}/vivado/script/synth_constraints.tcl
	@echo "----------------------------------------------------------------"
	@echo "---                         SYNTHESIS                        ---"
	@echo "----------------------------------------------------------------"
	@rm -rf ${BUILD_DIR}/vivado/sim
	@rm -rf ${BUILD_DIR}/xsct
	@echo "### INFO: Launching synthesis with top level module: ${TOP}"
	@vivado -mode batch -source script/vivado/synth.tcl -nojournal -notrace -log ${BUILD_DIR}/vivado/synth_out/synth.log -tclargs "${BUILD_DIR}/vivado" "${TOP}" "${PART}" "${BOARD_NAME}" "${SYNTHESIS_DIRECTIVE}" "${RTL_LANGUAGE}"
	@echo "### INFO: Synthesis terminated succesfully with top level module: ${TOP}"

${BUILD_DIR}/vivado/dcp/opt.dcp: ${BUILD_DIR}/vivado/dcp/synth.dcp ${BUILD_DIR}/vivado/script/opt_constraints.tcl
	@echo "----------------------------------------------------------------"
	@echo "---                        OPT DESIGN                        ---"
	@echo "----------------------------------------------------------------"
	@echo "### INFO: Launching OPT DESIGN for top level module: ${TOP}"
	@vivado -mode batch -source script/vivado/opt_design.tcl -nojournal -notrace ${BUILD_DIR}/vivado/dcp/synth.dcp -log ${BUILD_DIR}/vivado/opt_out/opt.log -tclargs "${BUILD_DIR}/vivado" "${PART}" "${OPT_DIRECTIVE}"
	@echo "### INFO: OPT DESIGN step successfully finished for top level module: ${TOP}"

${BUILD_DIR}/vivado/dcp/placement.dcp: ${BUILD_DIR}/vivado/dcp/opt.dcp ${BUILD_DIR}/vivado/script/placement_constraints.tcl
	@echo "----------------------------------------------------------------"
	@echo "---                         PLACEMENT                        ---"
	@echo "----------------------------------------------------------------"
	@echo "### INFO: Launching PLACEMENT for top level module: ${TOP}"
	@vivado -mode batch -source script/vivado/placement.tcl -nojournal -notrace ${BUILD_DIR}/vivado/dcp/opt.dcp -log ${BUILD_DIR}/vivado/placement_out/placement.log -tclargs "${BUILD_DIR}/vivado" "${PLACEMENT_DIRECTIVE}"
	@echo "### INFO: PLACEMENT step successfully finished for top level module: ${TOP}"

${BUILD_DIR}/vivado/dcp/route.dcp: ${BUILD_DIR}/vivado/dcp/placement.dcp ${BUILD_DIR}/vivado/script/route_constraints.tcl
	@echo "----------------------------------------------------------------"
	@echo "---                           ROUTE                          ---"
	@echo "----------------------------------------------------------------"
	@echo "### INFO: Launching ROUTE for top level module: ${TOP}"
	@vivado -mode batch -source script/vivado/route.tcl -nojournal -notrace ${BUILD_DIR}/vivado/dcp/placement.dcp -log ${BUILD_DIR}/vivado/route_out/route.log -tclargs "${BUILD_DIR}/vivado" "${ROUTE_DIRECTIVE}"
	@echo "### INFO: ROUTE step successfully finished for top level module: ${TOP}"

${BUILD_DIR}/vivado/system.xsa: ${BUILD_DIR}/vivado/dcp/route.dcp ${BUILD_DIR}/vivado/script/bitstream_constraints.tcl
	@echo "----------------------------------------------------------------"
	@echo "---                   BITSTREAM GENERATION                   ---"
	@echo "----------------------------------------------------------------"
	@echo "### INFO: Generating bitstream and hardware definition file for top level module: ${TOP}"
	@vivado -mode batch -source script/vivado/bitstream.tcl -nojournal -notrace ${BUILD_DIR}/vivado/dcp/route.dcp -log ${BUILD_DIR}/vivado/bitstream_out/bitstream.log -tclargs "${BUILD_DIR}/vivado" "${USE_PROBES}"
	@echo "### INFO: Bitstream and hardware definition file successfully created for top level module: ${TOP}"

.PHONY: vivado-synth
vivado-all: ${BUILD_DIR}/vivado/dcp/synth.dcp

.PHONY: vivado-opt-design
vivado-all: ${BUILD_DIR}/vivado/dcp/opt.dcp

.PHONY: vivado-placement
vivado-all: ${BUILD_DIR}/vivado/dcp/placement.dcp

.PHONY: vivado-route
vivado-all: ${BUILD_DIR}/vivado/dcp/placement.dcp

.PHONY: vivado-all
vivado-all: ${BUILD_DIR}/vivado/system.xsa

.PHONY: vivado-gui
vivado-gui: ${BUILD_DIR}/vivado/script/synth_sources.tcl ${BUILD_DIR}/vivado/script/synth_constraints.tcl
	@echo "### INFO: Opening Vivado in gui mode"
	@vivado -nojournal -nolog -notrace -source ${PWD}/script/vivado/import_synth.tcl -tclargs "${BUILD_DIR}/vivado" "${RTL_LANGUAGE}" "rtl" "${PART}" "${BOARD_NAME}" 0
	@echo "Would you like to save the modifications? [y/N]"
	@read  rc; \
	if [[ "$${rc}" == @(y|Y) ]]; then \
	  echo "### INFO: Copying source files from ${BUILD_DIR}/vivado/build to ${PWD}/rtl/synth"; \
	  bash ${BUILD_DIR}/vivado/script/save_sources.sh; \
	else \
	  echo "### INFO: Modified files from ${BUILD_DIR}/vivado/build not saved"; \
	  bash ${BUILD_DIR}/vivado/script/restore_sources.sh; \
	fi

.PHONY: vivado-gui-synth
vivado-gui-synth: ${BUILD_DIR}/vivado/dcp/synth.dcp
	@echo "### INFO: Opening Vivado synthetized design in gui mode"
	@vivado -nojournal -nolog ${BUILD_DIR}/vivado/dcp/synth.dcp

.PHONY: vivado-gui-opt
vivado-gui-opt: ${BUILD_DIR}/vivado/dcp/opt.dcp
	@echo "### INFO: Opening Vivado opt design in gui mode"
	@vivado -nojournal -nolog ${BUILD_DIR}/vivado/dcp/opt.dcp

.PHONY: vivado-gui-placement
vivado-gui-placement: ${BUILD_DIR}/vivado/dcp/placement.dcp
	@echo "### INFO: Opening Vivado placed design in gui mode"
	@vivado -nojournal -nolog ${BUILD_DIR}/vivado/dcp/placement.dcp

.PHONY: vivado-gui-route
vivado-gui-route: ${BUILD_DIR}/vivado/dcp/route.dcp
	@echo "### INFO: Opening Vivado routed design in gui mode"
	@vivado -nojournal -nolog ${BUILD_DIR}/vivado/dcp/route.dcp

.PHONY: vivado-clean
vivado-clean:
	@echo "### INFO: Cleaning vivado outputs"
	@rm -rf ${BUILD_DIR}/vivado

