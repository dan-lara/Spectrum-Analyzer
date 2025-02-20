# Copyright 2022 Raphaël Bresson

# Force Makefile to use bash
SHELL := /bin/bash

#COMMON USER CONFIG
NVERBOSE     ?= 0
#PROJECT_NAME ?= sigma_delta
PROJECT_NAME ?= spectrum_analyzer
#BOARD_NAME   ?= xilinx_kria
BOARD_NAME ?= avnet_zedboard

RTL_LANGUAGE ?= VHDL
USE_PROBES   ?= NO

# SIMULATION USER CONFIG
SIM_MODE ?= gui
SIMULATOR ?= xsim
#SIMULATOR ?= ghdl
#SIM_TOP  ?= tb_top

WORK_DIR ?= ${PWD}/build
INSTALL_DIR ?= ${WORK_DIR}/install
BUILD_DIR ?= ${WORK_DIR}/${PROJECT_NAME}_${BOARD_NAME}
PROJECT_DIR ?= ${PWD}/project/${PROJECT_NAME}
PROJECT_MK = ${PROJECT_DIR}/${BOARD_NAME}.mk
include ${PROJECT_MK}

all: all-target

.PHONY: clean
clean: vivado-clean xsct-clean buildroot-clean sim-clean hw-emu-clean

.PHONY: mrproper
mrproper:
	@rm -rf ${BUILD_DIR}

include mk/find-files.mk
include mk/board.mk
include mk/qemu.mk
include mk/vivado.mk
include mk/xsct.mk
include mk/xsim.mk
include mk/xsim-hw_emu.mk
include mk/buildroot.mk
include mk/get.mk

all-target: ${MAIN_TARGET}
