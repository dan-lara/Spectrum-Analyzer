${QEMU_BIN} -M arm-generic-fdt-7series \
            -nographic \
            -display none \
            -serial null \
            -serial mon:stdio \
            -m 1G \
            -gdb tcp::9000 \
            -machine-path ${MACHINE_PATH} \
            -kernel ${ELF} \
            -hw-dtb ${QEMU_DTB}
