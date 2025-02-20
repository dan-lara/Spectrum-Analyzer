ifndef (${led_blink_INCLUDED})
  led_blink_INCLUDED = 1
  led_blink_DIR    = ${PWD}/rtl/led_blink

  led_blink_SYNTH_SRC += ${led_blink_DIR}/synth/pkg_led_blink.vhd
  led_blink_SYNTH_SRC += ${led_blink_DIR}/synth/led_blink.vhd

  led_blink_SIM_SRC +=
  led_blink_SIM_TB +=

  SYNTH_SRC += ${led_blink_SYNTH_SRC}
  SIM_SRC   += ${led_blink_SIM_SRC}
  SIM_TB    += ${led_blink_SIM_TB}

  RTL_MODULES_DEF += ${led_blink_DIR}/sources.mk
  RTL_MODULES     += led_blink
endif
