# mk folder

Description
----
This folder is dedicated to makefiles used internally by the workflow. User should not modify anything here.

Content
----
- `board.mk` contains predefined parameters for supported boards
- `vivado.mk` contains targets for generating IP and BLOCK DESIGN output products then making bitstream
- `xsct.mk` contains targets to handle device-tree and fsbl baremetal build
- `xsim.mk` contains targets for behavioral simulation
- `xsim-hw_emu.mk` contains targets for hardware emulation
- `buildroot.mk` contains targets to build buildroot distribution
- `qemu.mk` contains target to build Xilinx modified version of QEMU (mandatory for hardware emulation)
