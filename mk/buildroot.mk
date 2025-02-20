# Copyright 2021 Raphaël Bresson
# buildroot initial build

MAKE_BUILDROOT = make O=${BUILD_DIR}/buildroot-output BR2_EXTERNAL=${PWD}/buildroot -C ${BUILD_DIR}/buildroot

${BUILD_DIR}/buildroot:
	@echo "----------------------------------------------------------------"
	@echo "---           PREPARE BUILDROOT BUILD DIRECTORY              ---"
	@echo "----------------------------------------------------------------"
	@echo "### INFO: Cloning Xilinx Buildroot repository in directory $@"
	@cd ${BUILD_DIR} && git clone https://github.com/buildroot/buildroot.git -b 2022.11
	@echo "### INFO: Configuring Buildroot"
	@${MAKE_BUILDROOT} ${BR2_DEFCONFIG}

.PHONY: buildroot-force-defconfig
buildroot-force-defconfig:
	@echo "### INFO: Reconfiguring Buildroot"
	@${MAKE_BUILDROOT} ${BR2_DEFCONFIG}

# clean buildroot
.PHONY: buildroot-clean
buildroot-clean:
	@echo "### INFO: Cleaning Buildroot outputs"
	@rm -rf ${BUILD_DIR}/buildroot ${BUILD_DIR}/buildroot-output

# update buildroot
${BUILD_DIR}/buildroot-output/images/boot/BOOT.BIN: buildroot/board/${BR2_BOARD}/dts/system-top.dts buildroot/board/${BR2_BOARD}/fsbl.elf | ${BUILD_DIR}/buildroot
	@echo "----------------------------------------------------------------"
	@echo "---              BUILDROOT DISTRIBUTION BUILD                ---"
	@echo "----------------------------------------------------------------"
	@${MAKE_BUILDROOT}

.PHONY: buildroot-force-update
buildroot-force-update:
	@echo "### INFO: Building/Updating Buildroot GNU/Linux distribution"
	@${MAKE_BUILDROOT}

.PHONY: buildroot-update
buildroot-update: ${BUILD_DIR}/buildroot-output/images/boot/BOOT.BIN

.PHONY: buildroot-cmd
buildroot-cmd:
	@echo "### INFO: Building Buildroot target: ${CMD}"
	@if [[ "${CMD}" == *[!\ ]* ]]; then \
		${MAKE_BUILDROOT} ${CMD}; \
	else \
		echo "### ERROR: Mandatory argument \"CMD\" not specified for target $@"; \
		echo "### USAGE: make buildroot-cmd CMD=<your command>"; \
		echo "### EXEMPLE: make buildroot-cmd CMD=menuconfig"; \
	fi

.PHONY: buildroot-cpio-build
buildroot-cpio-build: ${BUILD_DIR}/buildroot-output/images/boot/BOOT.BIN
	@echo "### INFO: Building Buildroot CPIO RootFS"
	@${MAKE_BUILDROOT} ${BR2_CPIO_DEFCONFIG}
	@${MAKE_BUILDROOT}
	@${MAKE_BUILDROOT} ${BR2_DEFCONFIG}

