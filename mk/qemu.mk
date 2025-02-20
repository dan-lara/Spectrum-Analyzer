XILINX_QEMU_GIT = https://github.com/Xilinx/qemu.git
XILINX_QEMU_VERSION = 21adc9f99e813fb24fb65421259b5b0614938376
XILINX_QEMU_AARCH64_BIN = ${INSTALL_DIR}/bin/qemu-system-aarch64
XILINX_QEMU_MICROBLAZE_BIN = ${INSTALL_DIR}/bin/qemu-system-microblazeel
${WORK_DIR}:
	mkdir -p $@
	mkdir -p ${INSTALL_DIR}

${WORK_DIR}/qemu: | ${WORK_DIR}
	@echo "----------------------------------------------------------------"
	@echo "---                        QEMU BUILD                        ---"
	@echo "----------------------------------------------------------------"
	cd ${WORK_DIR} && git clone ${XILINX_QEMU_GIT} qemu
	cd ${WORK_DIR}/qemu && git checkout ${XILINX_QEMU_VERSION}
	cd ${WORK_DIR}/qemu && git submodule update --init dtc
	mkdir -p ${WORK_DIR}/qemu/build
	cd ${WORK_DIR}/qemu/build && ../configure --target-list="aarch64-softmmu,microblazeel-softmmu,arm-softmmu" --enable-fdt --disable-kvm --disable-xen --enable-gcrypt --prefix="${INSTALL_DIR}"
	make -j8 -C ${WORK_DIR}/qemu/build all install

