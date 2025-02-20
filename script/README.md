# script folder

Description
----
This folder is dedicated to scripts used internally by the workflow. User should not modify anything here.

Organization
----
- `hw_emu/` contains qemu invocation bash scripts. See [Hardware emulation scripts README](hw_emu/README.md) for more informations
- `vivado/` constains Vivado tcl scripts (synthesis, Place&Route, RTL design files importing). See [Vivado scripts README](vivado/README.md) for more informations
- `xsct/` constains scripts related to xsct (device-tree generation, bootloader(s) generation, xilinx software platform generation for baremetal build, boot jtag) See [XSCT scripts README](xsct/README.md) for more informations
