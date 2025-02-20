# rtl folder

Description
----
This folder is dedicated to RTL IPs (VHDL/Verilog). It is organized in subfolders.
Each subfolder contains a file, `sources.mk`, which list all files to import for an IP.

Organization
----
- `<ip0_name>/`
  - `sources.mk`
  - `synth/`
    - `<ip_vhdl_file>.vhd`
    - `<ip_verilog_file>.v`
    - `<ip_system_verilog_file>.sv`
  - `sim/`
    - `<ip_sim_vhdl_file>.vhd`
    - `<ip_sim_verilog_file>.v`
    - `<ip_sim_system_verilog_file>.sv`

Syntax of the sources.mk file
----
Two variables can be setted (`+=` operator):
- `SYNTH_SRC` should contain the path of all synthetizable files
- `SIM_SRC` should contain the path of all simulation only files (BFMs, local testbenchs, etc.)

All project parameters can be used to add conditions.

Example:

```make
MY_IP_DIR = ${PWD}/rtl/my_ip
SYNTH_SRC += ${MY_IP_DIR}/synth/my_vhdl_file.vhd
ifeq (${BOARD_NAME}, my_board_name)
  SYNTH_SRC += ${MY_IP_DIR}/synth/my_verilog_file_for_my_board.v
else
  SYNTH_SRC += my_generic_system_verilog_file.sv
endif
SIM_FILES += my_vhdl_local_testbench.vhd
```
