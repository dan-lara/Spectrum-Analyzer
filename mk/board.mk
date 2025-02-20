# Copyright 2022 Raphaël Bresson

ifeq (${BOARD_NAME}, xilinx_kria)
PART               = xck26-sfvc784-2LV-c
BOARD              = xilinx.com:kv260_som:part0:1.4
SOC_FAMILY         = zynqmp
XSCT_BOARD         = zynqmp-smk-k26-reva
XSCT_SOC_FAMILY    = zynqmp
BR2_BOARD          = zynqmp-kria
BR2_DEFCONFIG      = zynqmp_kria_defconfig
BR2_CPIO_DEFCONFIG = zynqmp_kria_cpio_defconfig
MAIN_TARGET        = buildroot-update
QEMU_PLRP_DTS      = zynqmp-pl-remoteport.dtsi
QEMU_BASE_DTS      = board-zynqmp-k26-starterkit-virt.dts
QEMU_PSU_DTS       = zynqmp-k26-cosim.dts
QEMU_PSU_DTB       = zynqmp-k26-cosim.dtb
QEMU_PMU_DTB       = zynqmp-pmu.dtb
endif

ifeq (${BOARD_NAME}, avnet_zedboard)
PART               = xc7z020clg484-1
BOARD              = avnet.com:zedboard:part0:1.4
SOC_FAMILY         = zynq
XSCT_BOARD         = zedboard
XSCT_SOC_FAMILY    = zynq
BR2_BOARD          = zynq-zedboard
BR2_DEFCONFIG      = zynq_zedboard_defconfig
BR2_CPIO_DEFCONFIG = zynq_zedboard_cpio_defconfig
MAIN_TARGET        = buildroot-update
QEMU_PLRP_DTS      = zynq-pl-remoteport.dtsi
endif

SUPPORTED_BOARDS += xilinx_kria
SUPPORTED_BOARDS += avnet_zedboard
