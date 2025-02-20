# Copyright 2021 Raphaël Bresson

RTL_MODULES_AVAILABLE = $(shell ls -d rtl/*/ | sed 's+rtl/++g' | sed 's+/++g')
BAREMETAL_PROJECTS = $(shell ls -d baremetal/*/ | sed 's+baremetal/++g' | sed 's+/++g')
FREERTOS_PROJECTS = $(shell ls -d freertos/*/ | sed 's+freertos/++g' | sed 's+/++g')
PROJECTS = $(shell ls -d project/*/ | sed 's+project/++g' | sed 's+/++g')
PROJECT_BOARDS = $(shell ls -d project/${PROJECT_NAME}/*/ | sed 's+project/${PROJECT_NAME}/++g' | sed 's+/++g')

# BOARD SUPPORTED
.PHONY: list-supported-boards
list-supported-boards:
	@echo "${SUPPORTED_BOARDS}"

.PHONY: list-projects
list-projects:
	@echo "${PROJECTS}"

.PHONY: list-project-supported-boards
list-project-supported-boards:
	@echo "${PROJECT_BOARDS}"

.PHONY: list-rtl-modules
list-rtl-modules:
	@echo "${RTL_MODULES_AVAILABLE}"

.PHONY: list-baremetal-projects
list-baremetal-projects:
	@echo "${BAREMETAL_PROJECTS}"

.PHONY: list-freertos-projects
list-freertos-projects:
	@echo "${FREERTOS_PROJECTS}"
