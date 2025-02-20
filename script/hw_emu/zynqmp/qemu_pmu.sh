${QEMU_BIN} -M microblaze-fdt \
            -machine-path ${MACHINE_PATH} \
            -serial mon:stdio \
            -display none \
            -device loader,file=${ELF} \
            -device loader,addr=0xfd1a0074,data=0x1011003,data-len=4 \
            -device loader,addr=0xfd1a007C,data=0x1010f03,data-len=4 \
            -gdb tcp::9010 \
            -hw-dtb ${QEMU_DTB}
