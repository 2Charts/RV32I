# cocotb Makefile

SIM ?= verilator
TOPLEVEL_LANG = verilog

SRCS += register_file.sv
SRCS += rv32_pkg.sv
SRCS += rv32_alu.sv
SRCS += rv32_imm_ext.sv
SRCS += rv32_lsu.sv
SRCS += rv32_cu.sv
SRCS += rv32_core.sv

VERILOG_SOURCES += $(addprefix $(PWD)/src/,$(SRCS))

COCOTB_TOPLEVEL = rv32_core

export PYTHONPATH := $(PWD)/tb

WAVES = 1
EXTRA_ARGS += --trace --trace-fst --trace-structs

COCOTB_TEST_MODULES = tb

include $(shell cocotb-config --makefiles)/Makefile.sim
