${QEMU_BIN} -M microblaze-fdt \
            -machine-path ${MACHINE_PATH} \
            -serial mon:stdio \
            -display none \
            -kernel ${PMU_ROM} \
            -device loader,file=${ELF} \
            -gdb tcp::9010 \
            -hw-dtb ${QEMU_DTB} \
            -device loader,addr=0xfd1a0074,data=0x01011003,data-len=4 \
            -device loader,addr=0xfd1a007c,data=0x01010f03,data-len=4 \
            -d guest_errors

            #-device loader,addr=0xffca0038,data=0x000001ff,data-len=4 \
            #-device loader,addr=0xffff0000,data=0x14000000,data-len=4 \

