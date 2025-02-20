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

[ -d ${BINARIES_DIR}/zynq ] || mkdir ${BINARIES_DIR}/zynq
[ -d ${BINARIES_DIR}/boot ] || mkdir ${BINARIES_DIR}/boot

cp ${BOARD_DIR}/fsbl.elf ${BINARIES_DIR}/zynq
cp ${BOARD_DIR}/fpga.bit ${BINARIES_DIR}/zynq
cp ${BOARD_DIR}/boot.bif ${BINARIES_DIR}/zynq

cp ${BINARIES_DIR}/u-boot.elf ${BINARIES_DIR}/zynq/u-boot.elf

echo "[POST IMAGE] : Generating boot_jtag.scr"
${UBOOT_DIR}/tools/mkimage -C none -A arm -T script -d ${BR2_EXTERNAL_IMPL_PATH}/board/zynq-zedboard/boot_jtag.cmd ${BINARIES_DIR}/boot_jtag.scr

echo "[POST IMAGE] : Generating BOOT.BIN"
cd ${BINARIES_DIR}/zynq
bootgen -arch zynq -image ${BINARIES_DIR}/zynq/boot.bif -o ${BINARIES_DIR}/boot/BOOT.BIN -w

cp ${BINARIES_DIR}/uImage ${BINARIES_DIR}/boot
cp ${BINARIES_DIR}/system.dtb ${BINARIES_DIR}/boot/devicetree.dtb
#cp ${BINARIES_DIR}/rootfs.cpio.uboot ${BINARIES_DIR}/boot/uramdisk.image.gz
