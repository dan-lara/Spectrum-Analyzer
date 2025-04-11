ifndef (${vga_INCLUDED})
  vga_INCLUDED = 1
  vga_DIR    = ${PWD}/rtl/vga

  vga_SYNTH_SRC += ${vga_DIR}/synth/vga_pkg.vhd
  vga_SYNTH_SRC += ${vga_DIR}/synth/vga.vhd
  vga_SYNTH_SRC += ${vga_DIR}/synth/topDisplaySystem.vhd
  vga_SYNTH_SRC += ${vga_DIR}/synth/ip_vga.vhd

  vga_SIM_SRC += ${vga_DIR}/sim/tb_vga.vhd
  vga_SIM_TB +=  tb_vga

  SYNTH_SRC += ${vga_SYNTH_SRC}
  SIM_SRC   += ${vga_SIM_SRC}
  SIM_TB    += ${vga_SIM_TB}

  RTL_MODULES_DEF += ${vga_DIR}/sources.mk
  RTL_MODULES     += vga
endif