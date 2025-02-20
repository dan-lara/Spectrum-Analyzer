${QEMU_BIN} -M arm-generic-fdt \
            -nographic \
            -display none \
            -serial null \
            -serial mon:stdio \
            -m 4G \
            -gdb tcp::9000 \
            -machine-path ${MACHINE_PATH} \
            -global xlnx,zynqmp-boot.use-pmufw=false \
            -global xlnx,zynqmp-boot.cpu-num=0 \
            -device loader,file=${ELF},cpu-num=0 \
            -device loader,addr=0xfd1a0104,data=0x8000000e,data-len=4 \
            -hw-dtb ${QEMU_DTB}

            #-global xlnx,zynqmp-boot.use-pmufw=true \
            #-net nic \
            #-net nic \
            #-net nic \
            #-net user \

            #-device loader,file=${ELF},cpu-num=0 \
            #-kernel ${ELF} \
