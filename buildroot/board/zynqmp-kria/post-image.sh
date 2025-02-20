#!/bin/sh

BOARD_DIR="$(dirname $0)"

FIRST_DT=$(sed -nr \
               -e 's|^BR2_LINUX_KERNEL_INTREE_DTS_NAME="xilinx/([-_/[:alnum:]\\.]*).*"$|\1|p' \
               ${BR2_CONFIG})

UBOOT_DIR="$(find ${BASE_DIR}/build/ -name "uboot-xlnx*" -type d)"

if [ -z "${FIRST_DT}" ]
then
  # Look for CUSTOM DTS
  file_list=$(sed -nr \
                  -e 's|^BR2_LINUX_KERNEL_CUSTOM_DTS_PATH="([^"]+)"|\1|p' \
                  ${BR2_CONFIG})
  custom_dts=""
  for file in ${file_list}
  do
    if [ "${file##*.}" = "dts" ]
    then
        custom_dts=$file
    fi
  done
  FIRST_DT=$(basename ${custom_dts})
  FIRST_DT=${FIRST_DT%%.*}
fi

[ -z "${FIRST_DT}" ] || ln -fs ${FIRST_DT}.dtb ${BINARIES_DIR}/system.dtb

[ -d ${BINARIES_DIR}/zynqmp ] || mkdir ${BINARIES_DIR}/zynqmp
[ -d ${BINARIES_DIR}/boot ] || mkdir ${BINARIES_DIR}/boot


if [ -f ${BINARIES_DIR}/rootfs.cpio.uboot ]; then
  cp ${BINARIES_DIR}/rootfs.cpio.uboot ${BINARIES_DIR}/boot/uramdisk.uboot
fi

cp ${BOARD_DIR}/boot.bif ${BINARIES_DIR}/zynqmp/boot.bif
cp ${BINARIES_DIR}/Image.lzma ${BINARIES_DIR}/zynqmp/Image.lzma

echo "[POST IMAGE] : Generating boot_jtag.scr"
${UBOOT_DIR}/tools/mkimage -C none -A arm64 -T script -d ${BR2_EXTERNAL_IMPL_PATH}/board/zynqmp-kria/boot_jtag.cmd ${BINARIES_DIR}/boot_jtag.scr

echo "[POST IMAGE] : Generating BOOT.BIN"
#cp ${BOARD_DIR}/bl31.elf ${BINARIES_DIR}/zynqmp
cp ${BOARD_DIR}/pmufw.elf ${BINARIES_DIR}/zynqmp
cp ${BOARD_DIR}/fsbl.elf ${BINARIES_DIR}/zynqmp
cp ${BOARD_DIR}/fpga.bit ${BINARIES_DIR}/zynqmp


cp ${BINARIES_DIR}/u-boot.elf ${BINARIES_DIR}/zynqmp/u-boot.elf
cp ${BINARIES_DIR}/bl31.elf ${BINARIES_DIR}/zynqmp/bl31.elf
cp ${BINARIES_DIR}/system.dtb ${BINARIES_DIR}/zynqmp/devicetree.dtb

cd ${BINARIES_DIR}/zynqmp

bootgen -arch zynqmp -image ${BINARIES_DIR}/zynqmp/boot.bif -o ${BINARIES_DIR}/boot/BOOT.BIN -w


cp ${BINARIES_DIR}/Image.lzma ${BINARIES_DIR}/boot
cp ${BINARIES_DIR}/system.dtb ${BINARIES_DIR}/boot/devicetree.dtb

