HW_EMU_SIM_SCRIPT=$(shell find ${BUILD_DIR}/xsim-hw_emu/build/build/xsim/ -name *.sh)
HW_EMU_DESIGN_NAME = $(notdir $(basename ${HW_EMU_SIM_SCRIPT}))
VIVADO_PATH = ${XILINX_VIVADO}
VIVADO_LIB_PATH = ${VIVADO_PATH}/lib/lnx64.o/Ubuntu:${VIVADO_PATH}/lib/lnx64.o
XSIM_LIB_PATH = ${VIVADO_PATH}/data/xsim
PROTECTED_MODELS_LIB_PATH = ${VIVADO_PATH}/data/simmodels/xsim/2022.2/lnx64/6.2.0/systemc/protected
EXT_MODELS_LIB_PATH = ${VIVADO_PATH}/data/simmodels/xsim/2022.2/lnx64/6.2.0/ext
XILINX_BOOST_LIB_PATH = ${VIVADO_PATH}/tps/boost_1_72_0
XSC_CC_CMD = $(shell grep "xsc -c " ${HW_EMU_SIM_SCRIPT} | sed 's+$$xv_cxl_lib_path+${XSIM_LIB_PATH}+g' \
                                                         | sed 's+$$xv_cpt_lib_path+${PROTECTED_MODELS_LIB_PATH}+g' \
                                                         | sed 's+$$xv_ext_lib_path+${EXT_MODELS_LIB_PATH}+g' \
                                                         | sed 's+$$xv_boost_lib_path+${XILINX_BOOST_LIB_PATH}+g' \
                                                         | sed 's+xsc.prj+${BUILD_DIR}/xsim-hw_emu/build/build/xsim/xsc.prj+g')

XSC_LD_CMD = $(shell grep "xsc --shared " ${HW_EMU_SIM_SCRIPT} | sed 's+$$xv_cxl_lib_path+${XSIM_LIB_PATH}+g' \
                                                               | sed 's+$$xv_cpt_lib_path+${PROTECTED_MODELS_LIB_PATH}+g' \
                                                               | sed 's+$$xv_ext_lib_path+${EXT_MODELS_LIB_PATH}+g' \
                                                               | sed 's+$$xv_boost_lib_path+${XILINX_BOOST_LIB_PATH}+g')

HW_EMU_ELAB_OPT = $(shell grep "xelab --incr" ${HW_EMU_SIM_SCRIPT} | sed 's/xelab //g' \
                                                                   | sed 's/-log elaborate.log//g' \
                                                                   | sed 's/ ${HW_EMU_DESIGN_NAME} / ${TOP} /g' \
                                                                   | sed 's/xil_defaultlib.${HW_EMU_DESIGN_NAME}/xil_defaultlib.${TOP}/g' \
                                                                   | sed 's+$$xv_cxl_lib_path+${XSIM_LIB_PATH}+g' \
                                                                   | sed 's+$$xv_cpt_lib_path+${PROTECTED_MODELS_LIB_PATH}+g' \
                                                                   | sed 's+$$xv_ext_lib_path+${EXT_MODELS_LIB_PATH}+g' \
                                                                   | sed 's+$$xv_boost_lib_path+${XILINX_BOOST_LIB_PATH}+g')

HW_EMU_LD_PATH = $(shell grep "export LD_LIBRARY_PATH" ${HW_EMU_SIM_SCRIPT} | sed 's+$$PWD+${BUILD_DIR}/xsim-hw_emu/build/build/xsim+g' \
                                                                            | sed 's+$$xv_lib_path+${VIVADO_LIB_PATH}+g' \
                                                                            | sed 's+$$xv_ref_path+${VIVADO_PATH}+g' \
                                                                            | sed 's+export LD_LIBRARY_PATH=++g')


HW_EMU_VHDL_OPT=$(shell grep "xvhdl_opts=" ${HW_EMU_SIM_SCRIPT} | sed 's/xvhdl_opts=//g' | sed 's/\"//g') --work xil_defaultlib
HW_EMU_VLOG_OPT=$(shell grep "xvlog_opts=" ${HW_EMU_SIM_SCRIPT} | sed 's/xvlog_opts=//g' | sed 's/\"//g') --work xil_defaultlib ${GENERATED_IPSHARED_INCLUDE}

HW_EMU_VHDL_FILES           = $(shell echo ${HW_EMU_SRC} | tr ' ' '\n' | grep ".vhd")
HW_EMU_VERILOG_FILES        = $(shell echo ${HW_EMU_SRC} | tr ' ' '\n' | grep -v ".vhd" | grep -v ".vhdl" | grep -v ".sv" | grep -v ".bd" | grep -v ".xci")
HW_EMU_SYSTEM_VERILOG_FILES = $(shell echo ${HW_EMU_SRC} | tr ' ' '\n' | grep ".sv")

QEMU_MACHINE_PATH = build/machine

LINUX_FSBL      = ${BUILD_DIR}/xsct/fsbl/executable.elf
LINUX_PMUFW     = ${BUILD_DIR}/xsct/pmufw/executable.elf
LINUX_DTB       = ${BUILD_DIR}/buildroot-output/images/system-top.dtb
LINUX_SCR       = ${BUILD_DIR}/buildroot-output/images/boot_jtag.scr
LINUX_UBOOT     = ${BUILD_DIR}/buildroot-output/images/u-boot.elf
LINUX_BL31      = ${BUILD_DIR}/buildroot-output/images/bl31.elf
LINUX_KERNEL    = ${BUILD_DIR}/buildroot-output/images/Image.lzma
LINUX_INITRAMFS = ${BUILD_DIR}/buildroot-output/images/rootfs.cpio.uboot
LINUX_KERNEL7   = ${BUILD_DIR}/buildroot-output/images/uImage
LINUX_BOOT_BIN  = ${BUILD_DIR}/buildroot-output/images/boot/BOOT.BIN

${BUILD_DIR}/xsim-hw_emu/pmu-rom.elf: ${BUILD_DIR}/vivado
	@echo "----------------------------------------------------------------"
	@echo "---     HARDWARE EMULATION: DOWNLOAD AND EXTRACT PMU ROM     ---"
	@echo "----------------------------------------------------------------"
	@cd ${BUILD_DIR}/xsim-hw_emu && wget https://www.xilinx.com/bin/public/openDownload?filename=PMU_ROM.tar.gz -O PMU_ROM.tar.gz
	@cd ${BUILD_DIR}/xsim-hw_emu && tar xvzf PMU_ROM.tar.gz
	@cp ${BUILD_DIR}/xsim-hw_emu/PMU_ROM/pmu-rom.elf $@


${BUILD_DIR}/xsim-hw_emu/import-synth.done: ${BUILD_DIR}/vivado/script/synth_sources.tcl
	@echo "----------------------------------------------------------------"
	@echo "---    HARDWARE EMULATION SYNTHETIZABLE FILES IMPORTATION    ---"
	@echo "----------------------------------------------------------------"
	@rm -rf ${BUILD_DIR}/xsim-hw_emu/sim
	@vivado -mode batch -source script/vivado/import_synth.tcl -notrace -nojournal -nolog -tclargs "${BUILD_DIR}/xsim-hw_emu" "Verilog" "tlm" "${PART}" "${BOARD_NAME}" 1
	@echo "DONE" > ${BUILD_DIR}/xsim-hw_emu/import-synth.done

${BUILD_DIR}/xsim-hw_emu/qemu-devicetrees: | ${BUILD_DIR}/vivado
	@echo "----------------------------------------------------------------"
	@echo "---          QEMU XILINX DEVICE TREE COMPILATION             ---"
	@echo "----------------------------------------------------------------"
	@cd ${BUILD_DIR}/xsim-hw_emu && git clone https://github.com/Xilinx/qemu-devicetrees.git qemu-devicetrees
	@mkdir -p ${BUILD_DIR}/xsim-hw_emu/dts
	@if [ ${SOC_FAMILY} == "zynqmp" ]; then \
		echo "#include \"${QEMU_BASE_DTS}\"" > ${BUILD_DIR}/xsim-hw_emu/qemu-devicetrees/${QEMU_PSU_DTS}; \
		echo "#include \"${QEMU_PLRP_DTS}\"" >> ${BUILD_DIR}/xsim-hw_emu/qemu-devicetrees/${QEMU_PSU_DTS}; \
	  make -C ${BUILD_DIR}/xsim-hw_emu/qemu-devicetrees; \
	  cp ${BUILD_DIR}/xsim-hw_emu/qemu-devicetrees/LATEST/MULTI_ARCH/${QEMU_PSU_DTB} ${BUILD_DIR}/xsim-hw_emu/; \
	  cp ${BUILD_DIR}/xsim-hw_emu/qemu-devicetrees/LATEST/MULTI_ARCH/${QEMU_PMU_DTB} ${BUILD_DIR}/xsim-hw_emu/; \
	fi

${BUILD_DIR}/xsim-hw_emu/system.dtb: ${BUILD_DIR}/xsct/dts/system-top.dts | ${BUILD_DIR}/xsim-hw_emu/qemu-devicetrees
	@echo "----------------------------------------------------------------"
	@echo "---          QEMU SYSTEM DEVICE TREE COMPILATION             ---"
	@echo "----------------------------------------------------------------"
	@if [ "${SOC_FAMILY}" == "zynq" ]; then \
	  cp -r ${BUILD_DIR}/xsct/dts/* ${BUILD_DIR}/xsim-hw_emu/dts/; \
	  cp ${BUILD_DIR}/xsim-hw_emu/qemu-devicetrees/${QEMU_PLRP_DTS} ${BUILD_DIR}/xsim-hw_emu/dts/; \
	  echo "#include \"system-top.dts\"" > ${BUILD_DIR}/xsim-hw_emu/dts/system.dts; \
	  echo "#include \"${QEMU_PLRP_DTS}\"" >> ${BUILD_DIR}/xsim-hw_emu/dts/system.dts; \
	  gcc -E -nostdinc -x assembler-with-cpp -DMULTI_ARCH -MD -MF ${BUILD_DIR}/xsim-hw_emu/dts/system.dts.cd -I${BUILD_DIR}/xsim-hw_emu/dts -I${BUILD_DIR}/xsim-hw_emu/include -o ${BUILD_DIR}/xsim-hw_emu/dts/system.dts.i ${BUILD_DIR}/xsim-hw_emu/dts/system.dts; \
	  dtc -q -I dts -O dtb -o $@ ${BUILD_DIR}/xsim-hw_emu/dts/system.dts.i -b 0; \
	else \
	  touch $@; \
	fi

${BUILD_DIR}/xsim-hw_emu/build/build/xsim/xsim.ini: ${BUILD_DIR}/xsim-hw_emu/import-synth.done
	cp ${XSIM_LIB_PATH}/xsim.ini $@

${BUILD_DIR}/xsim-hw_emu/compile.done: ${BUILD_DIR}/xsim-hw_emu/build/build/xsim/xsim.ini
	@echo "----------------------------------------------------------------"
	@echo "---         HARDWARE EMULATION: FILES COMPILATION            ---"
	@echo "----------------------------------------------------------------"
	@mkdir -p ${BUILD_DIR}/xsim-hw_emu/log
	@if [ -f "${BUILD_DIR}/xsim-hw_emu/build/build/xsim/vhdl.prj" ]; then \
	  cd ${BUILD_DIR}/xsim-hw_emu/build/build/xsim/ && xvhdl ${HW_EMU_VHDL_OPT} -prj ${BUILD_DIR}/xsim-hw_emu/build/build/xsim/vhdl.prj -log ${BUILD_DIR}/xsim-hw_emu/log/xvhdl.log; \
	fi
	@if [ -f "${BUILD_DIR}/xsim-hw_emu/build/build/xsim/vlog.prj" ]; then \
	  cd ${BUILD_DIR}/xsim-hw_emu/build/build/xsim/ && xvlog ${HW_EMU_VLOG_OPT} -prj ${BUILD_DIR}/xsim-hw_emu/build/build/xsim/vlog.prj -log ${BUILD_DIR}/xsim-hw_emu/log/xvlog.log; \
	fi
	@if [ -f "${BUILD_DIR}/xsim-hw_emu/build/build/xsim/xsc.prj" ]; then \
	  cd ${BUILD_DIR}/xsim-hw_emu/build/build/xsim/ && ${XSC_CC_CMD}; \
	fi
	@bd_wrapper_verilog=`find ${BUILD_DIR}/xsim-hw_emu/build/hdl -name *.v`; \
	cd ${BUILD_DIR}/xsim-hw_emu/build/build/xsim/ && xvlog ${HW_EMU_VLOG_OPT} $${bd_wrapper_verilog} ${SYNTH_VERILOG_FILES} ${HW_EMU_VERILOG_FILES} -log ${BUILD_DIR}/xsim-hw_emu/log/verilog.log; \
	if [[ "${HW_EMU_SYSTEM_VERILOG_FILES} ${SYNTH_SYSTEM_VERILOG_FILES}" == *[!\ ]* ]]; then \
		xvlog -sv ${HW_EMU_VLOG_OPT} ${SYNTH_SYSTEM_VERILOG_FILES} ${HW_EMU_SYSTEM_VERILOG_FILES} -log ${BUILD_DIR}/xsim-hw_emu/log/systemverilog.log; \
	fi; \
	if [[ "${HW_EMU_VHDL_FILES} ${SYNTH_VHDL_FILES}" == *[!\ ]* ]]; then \
		xvhdl ${HW_EMU_VHDL_OPT} ${SYNTH_VHDL_FILES} ${HW_EMU_VHDL_FILES} -log ${BUILD_DIR}/xsim-hw_emu/log/vhdl.log; \
	fi
	@echo "done" > $@

${BUILD_DIR}/xsim-hw_emu/elab.done: ${BUILD_DIR}/xsim-hw_emu/compile.done
	@echo "----------------------------------------------------------------"
	@echo "---          HARDWARE EMULATION: ELABORATION                 ---"
	@echo "----------------------------------------------------------------"
	@echo "### INFO: Top level is: ${TOP}"
	@if [ -f "${BUILD_DIR}/xsim-hw_emu/build/build/xsim/xsc.prj" ]; then \
	  cd ${BUILD_DIR}/xsim-hw_emu/build/build/xsim/ && LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$$LIBRARY_PATH LD_LIBRARY_PATH=${HW_EMU_LD_PATH} ${XSC_LD_CMD}; \
	fi
	@cd ${BUILD_DIR}/xsim-hw_emu/build/build/xsim/ && LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$$LIBRARY_PATH LD_LIBRARY_PATH=${HW_EMU_LD_PATH} xelab ${HW_EMU_ELAB_OPT} --include=${BUILD_DIR}/xsim-hw_emu/build/build/xsim/ -log ${BUILD_DIR}/xsim-hw_emu/log/elab.log
	@echo "done" > $@

# -------------------------------------------------------------------------------------------------

.PHONY: hw-emu-baremetal-zynqmp
hw-emu-baremetal-zynqmp: ${BUILD_DIR}/xsim-hw_emu/elab.done ${BUILD_DIR}/xsim-hw_emu/system.dtb baremetal-build | ${WORK_DIR}/qemu
	@echo "----------------------------------------------------------------"
	@echo "---         HARDWARE EMULATION: Launching PMU QEMU           ---"
	@echo "----------------------------------------------------------------"
	@rm -rf ${QEMU_MACHINE_PATH}
	@mkdir -p ${QEMU_MACHINE_PATH}
	@QEMU_BIN=${XILINX_QEMU_MICROBLAZE_BIN} QEMU_DTB=${BUILD_DIR}/xsim-hw_emu/${QEMU_PMU_DTB} ELF=${XSCT_WS}/pfm_baremetal/export/pfm_baremetal/sw/pfm_baremetal/qemu/pmufw.elf MACHINE_PATH=${QEMU_MACHINE_PATH} xterm -hold -e bash ${PWD}/script/hw_emu/${SOC_FAMILY}/qemu_pmu.sh &
	@echo "----------------------------------------------------------------"
	@echo "---         HARDWARE EMULATION: Launching PSU QEMU           ---"
	@echo "----------------------------------------------------------------"
	@QEMU_BIN=${XILINX_QEMU_AARCH64_BIN} QEMU_DTB=${BUILD_DIR}/xsim-hw_emu/${QEMU_PSU_DTB} FSBL=${XSCT_WS}/pfm_baremetal/zynqmp_fsbl/fsbl_a53.elf ELF=${XSCT_WS}/${BM_PROJECT}/Debug/${BM_PROJECT}.elf MACHINE_PATH=${QEMU_MACHINE_PATH} xterm -hold -e bash ${PWD}/script/hw_emu/${SOC_FAMILY}/qemu_baremetal.sh &
	@echo "----------------------------------------------------------------"
	@echo "---           HARDWARE EMULATION: Launching XSIM             ---"
	@echo "----------------------------------------------------------------"
	@echo "### INFO: top level module: ${TOP}"
	@echo "### INFO: Generating tcl script build/xsim-hw_emu/script/xsim.tcl"
	@echo "log_wave -r *" > ${BUILD_DIR}/xsim-hw_emu/script/xsim.tcl
	@if [ "${SIM_MODE}" == "gui" ]; then \
		 cd ${BUILD_DIR}/xsim-hw_emu/build/build/xsim/ && LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$$LIBRARY_PATH LD_LIBRARY_PATH=${HW_EMU_LD_PATH} COSIM_MACHINE_PATH="unix:/${PWD}/${QEMU_MACHINE_PATH}/qemu-rport-_amba@0_cosim@0" xsim ${TOP} ${PROTOINST_DECLARE} -tclbatch ${BUILD_DIR}/xsim-hw_emu/script/xsim.tcl -gui -log ${BUILD_DIR}/xsim-hw_emu/log/xsim.log -wdb ${BUILD_DIR}/xsim-hw_emu/${TOP}.wdb; \
	else \
		cd ${BUILD_DIR}/xsim-hw_emu/build/build/xsim/ && LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$$LIBRARY_PATH LD_LIBRARY_PATH=${HW_EMU_LD_PATH} "COSIM_MACHINE_PATH=unix:/${PWD}/${QEMU_MACHINE_PATH}/qemu-rport-_amba@0_cosim@0" xsim ${TOP} ${PROTOINST_DECLARE} -R -log ${BUILD_DIR}/xsim/log/xsim-hw_emu.log; \
	fi

.PHONY: hw-emu-baremetal-zynq
hw-emu-baremetal-zynq: ${BUILD_DIR}/xsim-hw_emu/elab.done ${BUILD_DIR}/xsim-hw_emu/system.dtb baremetal-build | ${WORK_DIR}/qemu
	@echo "----------------------------------------------------------------"
	@echo "---         HARDWARE EMULATION: Launching PS7 QEMU           ---"
	@echo "----------------------------------------------------------------"
	@rm -rf ${QEMU_MACHINE_PATH}
	@mkdir -p ${QEMU_MACHINE_PATH}
	@QEMU_BIN=${XILINX_QEMU_AARCH64_BIN} QEMU_DTB=${BUILD_DIR}/xsim-hw_emu/system.dtb FSBL=${XSCT_WS}/pfm_baremetal/zynq_fsbl/fsbl_a9.elf ELF=${XSCT_WS}/${BM_PROJECT}/Debug/${BM_PROJECT}.elf MACHINE_PATH=${QEMU_MACHINE_PATH} xterm -hold -e bash ${PWD}/script/hw_emu/${SOC_FAMILY}/qemu_baremetal.sh &
	@echo "----------------------------------------------------------------"
	@echo "---           HARDWARE EMULATION: Launching XSIM             ---"
	@echo "----------------------------------------------------------------"
	@echo "### INFO: top level module: ${TOP}"
	@echo "### INFO: Generating tcl script build/xsim-hw_emu/script/xsim.tcl"
	@echo "log_wave -r *" > ${BUILD_DIR}/xsim-hw_emu/script/xsim.tcl
	@if [ "${SIM_MODE}" == "gui" ]; then \
		 cd ${BUILD_DIR}/xsim-hw_emu/build/build/xsim/ && LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$$LIBRARY_PATH LD_LIBRARY_PATH=${HW_EMU_LD_PATH} COSIM_MACHINE_PATH="${PWD}/${QEMU_MACHINE_PATH}" xsim ${TOP} ${PROTOINST_DECLARE} -tclbatch ${BUILD_DIR}/xsim-hw_emu/script/xsim.tcl -gui -log ${BUILD_DIR}/xsim-hw_emu/log/xsim.log -wdb ${BUILD_DIR}/xsim-hw_emu/${TOP}.wdb; \
	else \
		cd ${BUILD_DIR}/xsim-hw_emu/build/build/xsim/ && LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$$LIBRARY_PATH LD_LIBRARY_PATH=${HW_EMU_LD_PATH} COSIM_MACHINE_PATH="${PWD}/${QEMU_MACHINE_PATH}" xsim ${TOP} ${PROTOINST_DECLARE} -R -log ${BUILD_DIR}/xsim/log/xsim-hw_emu.log; \
	fi

.PHONY: hw-emu-baremetal
hw-emu-baremetal: hw-emu-baremetal-${SOC_FAMILY}

# ---------------------------------------------------------------------------------------------------------------------------------------------

.PHONY: hw-emu-freertos-zynqmp
hw-emu-freertos-zynqmp: ${BUILD_DIR}/xsim-hw_emu/elab.done ${BUILD_DIR}/xsim-hw_emu/system.dtb freertos-build | ${WORK_DIR}/qemu
	@echo "----------------------------------------------------------------"
	@echo "---         HARDWARE EMULATION: Launching PMU QEMU           ---"
	@echo "----------------------------------------------------------------"
	@rm -rf ${QEMU_MACHINE_PATH}
	@mkdir -p ${QEMU_MACHINE_PATH}
	@QEMU_BIN=${XILINX_QEMU_MICROBLAZE_BIN} QEMU_DTB=${BUILD_DIR}/xsim-hw_emu/${QEMU_PMU_DTB} ELF=${XSCT_FREE_RTOS_WS}/pfm_freertos/export/pfm_freertos/sw/pfm_freertos/qemu/pmufw.elf MACHINE_PATH=${QEMU_MACHINE_PATH} xterm -hold -e bash ${PWD}/script/hw_emu/${SOC_FAMILY}/qemu_pmu.sh &
	@echo "----------------------------------------------------------------"
	@echo "---         HARDWARE EMULATION: Launching PSU QEMU           ---"
	@echo "----------------------------------------------------------------"
	@QEMU_BIN=${XILINX_QEMU_AARCH64_BIN} QEMU_DTB=${BUILD_DIR}/xsim-hw_emu/${QEMU_PSU_DTB} FSBL=${XSCT_FREE_RTOS_WS}/pfm_freertos/zynqmp_fsbl/fsbl_a53.elf ELF=${XSCT_FREE_RTOS_WS}/${FREE_RTOS_PROJECT}/Debug/${FREE_RTOS_PROJECT}.elf MACHINE_PATH=${QEMU_MACHINE_PATH} xterm -hold -e bash ${PWD}/script/hw_emu/${SOC_FAMILY}/qemu_baremetal.sh &
	@echo "----------------------------------------------------------------"
	@echo "---           HARDWARE EMULATION: Launching XSIM             ---"
	@echo "----------------------------------------------------------------"
	@echo "### INFO: top level module: ${TOP}"
	@echo "### INFO: Generating tcl script build/xsim-hw_emu/script/xsim.tcl"
	@echo "log_wave -r *" > ${BUILD_DIR}/xsim-hw_emu/script/xsim.tcl
	@if [ "${SIM_MODE}" == "gui" ]; then \
		 cd ${BUILD_DIR}/xsim-hw_emu/build/build/xsim/ && LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$$LIBRARY_PATH LD_LIBRARY_PATH=${HW_EMU_LD_PATH} COSIM_MACHINE_PATH="unix:/${PWD}/${QEMU_MACHINE_PATH}/qemu-rport-_amba@0_cosim@0" xsim ${TOP} ${PROTOINST_DECLARE} -tclbatch ${BUILD_DIR}/xsim-hw_emu/script/xsim.tcl -gui -log ${BUILD_DIR}/xsim-hw_emu/log/xsim.log -wdb ${BUILD_DIR}/xsim-hw_emu/${TOP}.wdb; \
	else \
		cd ${BUILD_DIR}/xsim-hw_emu/build/build/xsim/ && LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$$LIBRARY_PATH LD_LIBRARY_PATH=${HW_EMU_LD_PATH} "COSIM_MACHINE_PATH=unix:/${PWD}/${QEMU_MACHINE_PATH}/qemu-rport-_amba@0_cosim@0" xsim ${TOP} ${PROTOINST_DECLARE} -R -log ${BUILD_DIR}/xsim/log/xsim-hw_emu.log; \
	fi

.PHONY: hw-emu-freertos-zynq
hw-emu-freertos-zynq: ${BUILD_DIR}/xsim-hw_emu/elab.done ${BUILD_DIR}/xsim-hw_emu/system.dtb freertos-build | ${WORK_DIR}/qemu
	@echo "----------------------------------------------------------------"
	@echo "---         HARDWARE EMULATION: Launching PS7 QEMU           ---"
	@echo "----------------------------------------------------------------"
	@rm -rf ${QEMU_MACHINE_PATH}
	@mkdir -p ${QEMU_MACHINE_PATH}
	@QEMU_BIN=${XILINX_QEMU_AARCH64_BIN} QEMU_DTB=${BUILD_DIR}/xsim-hw_emu/system.dtb FSBL=${XSCT_FREE_RTOS_WS}/pfm_freertos/zynq_fsbl/fsbl_a9.elf ELF=${XSCT_FREE_RTOS_WS}/${FREE_RTOS_PROJECT}/Debug/${FREE_RTOS_PROJECT}.elf MACHINE_PATH=${QEMU_MACHINE_PATH} xterm -hold -e bash ${PWD}/script/hw_emu/${SOC_FAMILY}/qemu_baremetal.sh &
	@echo "----------------------------------------------------------------"
	@echo "---           HARDWARE EMULATION: Launching XSIM             ---"
	@echo "----------------------------------------------------------------"
	@echo "### INFO: top level module: ${TOP}"
	@echo "### INFO: Generating tcl script build/xsim-hw_emu/script/xsim.tcl"
	@echo "log_wave -r *" > ${BUILD_DIR}/xsim-hw_emu/script/xsim.tcl
	@if [ "${SIM_MODE}" == "gui" ]; then \
		 cd ${BUILD_DIR}/xsim-hw_emu/build/build/xsim/ && LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$$LIBRARY_PATH LD_LIBRARY_PATH=${HW_EMU_LD_PATH} COSIM_MACHINE_PATH="${PWD}/${QEMU_MACHINE_PATH}" xsim ${TOP} ${PROTOINST_DECLARE} -tclbatch ${BUILD_DIR}/xsim-hw_emu/script/xsim.tcl -gui -log ${BUILD_DIR}/xsim-hw_emu/log/xsim.log -wdb ${BUILD_DIR}/xsim-hw_emu/${TOP}.wdb; \
	else \
		cd ${BUILD_DIR}/xsim-hw_emu/build/build/xsim/ && LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$$LIBRARY_PATH LD_LIBRARY_PATH=${HW_EMU_LD_PATH} COSIM_MACHINE_PATH="${PWD}/${QEMU_MACHINE_PATH}" xsim ${TOP} ${PROTOINST_DECLARE} -R -log ${BUILD_DIR}/xsim/log/xsim-hw_emu.log; \
	fi

.PHONY: hw-emu-freertos
hw-emu-freertos: hw-emu-freertos-${SOC_FAMILY}

# ---------------------------------------------------------------------------------------------------------------------------------------------

.PHONY: hw-emu-buildroot-zynqmp
hw-emu-buildroot-zynqmp: ${BUILD_DIR}/xsim-hw_emu/elab.done ${BUILD_DIR}/xsim-hw_emu/pmu-rom.elf buildroot-cpio-build ${BUILD_DIR}/xsim-hw_emu/system.dtb | ${WORK_DIR}/qemu
	@echo "----------------------------------------------------------------"
	@echo "---         HARDWARE EMULATION: Launching PMU QEMU           ---"
	@echo "----------------------------------------------------------------"
	@rm -rf ${QEMU_MACHINE_PATH}
	@mkdir -p ${QEMU_MACHINE_PATH}
	@QEMU_BIN=${XILINX_QEMU_MICROBLAZE_BIN} QEMU_DTB=${BUILD_DIR}/xsim-hw_emu/${QEMU_PMU_DTB} ELF=${LINUX_PMUFW} PMU_ROM=${BUILD_DIR}/xsim-hw_emu/pmu-rom.elf MACHINE_PATH=${QEMU_MACHINE_PATH} xterm -e bash ${PWD}/script/hw_emu/${SOC_FAMILY}/qemu_pmu_linux.sh &
	@echo "----------------------------------------------------------------"
	@echo "---         HARDWARE EMULATION: Launching PSU QEMU           ---"
	@echo "----------------------------------------------------------------"
	@QEMU_BIN=${XILINX_QEMU_AARCH64_BIN} QEMU_DTB=${BUILD_DIR}/xsim-hw_emu/${QEMU_PSU_DTB} UBOOT=${LINUX_UBOOT} FSBL=${LINUX_FSBL} BL31=${LINUX_BL31} KERNEL=${LINUX_KERNEL} INITRAMFS=${LINUX_INITRAMFS} DTB=${LINUX_DTB} SCR=${LINUX_SCR} MACHINE_PATH=${QEMU_MACHINE_PATH} xterm -hold -e bash ${PWD}/script/hw_emu/${SOC_FAMILY}/qemu_linux.sh &
	@echo "----------------------------------------------------------------"
	@echo "---           HARDWARE EMULATION: Launching XSIM             ---"
	@echo "----------------------------------------------------------------"
	@echo "### INFO: top level module: ${TOP}"
	@echo "### INFO: Generating tcl script build/xsim-hw_emu/script/xsim.tcl"
	@echo "log_wave -r *" > ${BUILD_DIR}/xsim-hw_emu/script/xsim.tcl
	@if [ "${SIM_MODE}" == "gui" ]; then \
		 cd ${BUILD_DIR}/xsim-hw_emu/build/build/xsim/ && LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$$LIBRARY_PATH LD_LIBRARY_PATH=${HW_EMU_LD_PATH} COSIM_MACHINE_PATH="unix:/${PWD}/${QEMU_MACHINE_PATH}/qemu-rport-_amba@0_cosim@0" xsim ${TOP} ${PROTOINST_DECLARE} -tclbatch ${BUILD_DIR}/xsim-hw_emu/script/xsim.tcl -gui -log ${BUILD_DIR}/xsim-hw_emu/log/xsim.log -wdb ${BUILD_DIR}/xsim-hw_emu/${TOP}.wdb; \
	else \
		 cd ${BUILD_DIR}/xsim-hw_emu/build/build/xsim/ && LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$$LIBRARY_PATH LD_LIBRARY_PATH=${HW_EMU_LD_PATH} COSIM_MACHINE_PATH="unix:/${PWD}/${QEMU_MACHINE_PATH}/qemu-rport-_amba@0_cosim@0" xsim ${TOP} ${PROTOINST_DECLARE} -R -log ${BUILD_DIR}/xsim-hw_emu/log/xsim.log -wdb ${BUILD_DIR}/xsim-hw_emu/${TOP}.wdb; \
	fi

.PHONY: hw-emu-buildroot-zynq
hw-emu-buildroot-zynq: ${BUILD_DIR}/xsim-hw_emu/elab.done ${BUILD_DIR}/xsim-hw_emu/system.dtb buildroot-cpio-build | ${WORK_DIR}/qemu
	@echo "----------------------------------------------------------------"
	@echo "---         HARDWARE EMULATION: Launching PS7 QEMU           ---"
	@echo "----------------------------------------------------------------"
	@rm -rf ${QEMU_MACHINE_PATH}
	@mkdir -p ${QEMU_MACHINE_PATH}
	@QEMU_BIN=${XILINX_QEMU_AARCH64_BIN} QEMU_DTB=${BUILD_DIR}/xsim-hw_emu/system.dtb FSBL=${LINUX_FSBL} UBOOT=${LINUX_UBOOT} KERNEL=${LINUX_KERNEL7} INITRAMFS=${LINUX_INITRAMFS} DTB=${LINUX_DTB} SCR=${LINUX_SCR} MACHINE_PATH=${QEMU_MACHINE_PATH} xterm -hold -e bash ${PWD}/script/hw_emu/${SOC_FAMILY}/qemu_linux.sh &
	@echo "----------------------------------------------------------------"
	@echo "---           HARDWARE EMULATION: Launching XSIM             ---"
	@echo "----------------------------------------------------------------"
	@echo "### INFO: top level module: ${TOP}"
	@echo "### INFO: Generating tcl script build/xsim-hw_emu/script/xsim.tcl"
	@echo "log_wave -r *" > ${BUILD_DIR}/xsim-hw_emu/script/xsim.tcl
	@if [ "${SIM_MODE}" == "gui" ]; then \
		 cd ${BUILD_DIR}/xsim-hw_emu/build/build/xsim/ && LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$$LIBRARY_PATH LD_LIBRARY_PATH=${HW_EMU_LD_PATH} COSIM_MACHINE_PATH="${PWD}/${QEMU_MACHINE_PATH}" xsim ${TOP} ${PROTOINST_DECLARE} -tclbatch ${BUILD_DIR}/xsim-hw_emu/script/xsim.tcl -gui -log ${BUILD_DIR}/xsim-hw_emu/log/xsim.log -wdb ${BUILD_DIR}/xsim-hw_emu/${TOP}.wdb; \
	else \
		cd ${BUILD_DIR}/xsim-hw_emu/build/build/xsim/ && LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$$LIBRARY_PATH LD_LIBRARY_PATH=${HW_EMU_LD_PATH} COSIM_MACHINE_PATH="${PWD}/${QEMU_MACHINE_PATH}" xsim ${TOP} ${PROTOINST_DECLARE} -R -log ${BUILD_DIR}/xsim/log/xsim-hw_emu.log; \
	fi

.PHONY: hw-emu-buildroot
hw-emu-buildroot: hw-emu-buildroot-${SOC_FAMILY}

.PHONY: hw-emu-clean
hw-emu-clean:
	@echo "### INFO: Cleaning hw emulation outputs"
	@rm -rf ${BUILD_DIR}/xsim-hw_emu/
