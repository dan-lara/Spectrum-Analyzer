${QEMU_BIN} -M arm-generic-fdt \
            -no-reboot \
            -display gtk \
            -serial null \
            -serial mon:stdio \
            -net nic \
            -net nic \
            -net nic \
            -net nic \
            -net user,net=10.10.70.0,dhcpstart=10.10.70.1,host=10.0.2.2 \
            -m 4G \
            -gdb tcp::9000 \
            -machine-path ${MACHINE_PATH} \
            -global xlnx,zynqmp-boot.use-pmufw=true \
            -global xlnx,zynqmp-boot.cpu-num=0 \
            -device loader,addr=0xfffc0000,data=0x584c4e5801000000,data-be=true,data-len=8 \
            -device loader,addr=0xfffc0008,data=0x0000000800000000,data-be=true,data-len=8 \
            -device loader,addr=0xfffc0010,data=0x1000000000000000,data-be=true,data-len=8 \
            -device loader,addr=0xffd80048,data=0xfffc0000,data-len=4,attrs-secure=on \
            -device loader,addr=0x18000000,file=${KERNEL},force-raw=on \
            -device loader,addr=0x40000000,file=${DTB},force-raw=on \
            -device loader,addr=0x20000000,file=${SCR},force-raw=on \
            -device loader,addr=0x02100000,file=${INITRAMFS},force-raw=on \
            -device loader,file=${BL31},cpu-num=0 \
            -device loader,file=${UBOOT} \
            -hw-dtb ${QEMU_DTB} \
            -boot mode=0

#-nographic \
