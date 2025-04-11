ifndef (${i2s_INCLUDED})
  i2s_INCLUDED = 1
  i2s_DIR    = ${PWD}/rtl/i2s

  i2s_SYNTH_SRC += ${i2s_DIR}/synth/i2s_pkg.vhd
  i2s_SYNTH_SRC += ${i2s_DIR}/synth/i2s_to_axi.vhd

  i2s_SIM_SRC += ${i2s_DIR}/sim/tb_i2s.vhd
  i2s_SIM_TB +=  tb_i2s_to_axi

  SYNTH_SRC += ${i2s_SYNTH_SRC}
  SIM_SRC   += ${i2s_SIM_SRC}
  SIM_TB    += ${i2s_SIM_TB}

  RTL_MODULES_DEF += ${i2s_DIR}/sources.mk
  RTL_MODULES     += i2s
endif