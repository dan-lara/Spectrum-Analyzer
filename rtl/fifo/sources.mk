ifndef (${fifo_INCLUDED})
  fifo_INCLUDED = 1
  fifo_DIR    = ${PWD}/rtl/fifo

  fifo_SYNTH_SRC += ${fifo_DIR}/synth/fifo_pkg.vhd
  fifo_SYNTH_SRC += ${fifo_DIR}/synth/fifo.vhd

  fifo_SIM_SRC += ${fifo_DIR}/sim/tb_fifo.vhd
  fifo_SIM_TB +=  tb_fifo

  SYNTH_SRC += ${fifo_SYNTH_SRC}
  SIM_SRC   += ${fifo_SIM_SRC}
  SIM_TB    += ${fifo_SIM_TB}

  RTL_MODULES_DEF += ${fifo_DIR}/sources.mk
  RTL_MODULES     += fifo
endif