# Target TB

TB_DIR := tb

# For different tb for testing -- Change VX_TB
VX_TB := VX_ahb_tb
TARGET_TB := $(TB_DIR)/$(VX_TB).sv

# Simulation option (Command line (-c) or GUI (-gui))
SIM_UI_OPT := -gui

### Directories 
# Vortex
RTL_DIR := rtl
AFU_DIR := $(RTL_DIR)/afu
CACHE_DIR := $(RTL_DIR)/cache
FP_CORE_DIR := $(RTL_DIR)/fp_cores
INTERFACES_DIR := $(RTL_DIR)/interfaces
LIBS_DIR := $(RTL_DIR)/libs
TEX_UNIT_DIR := $(RTL_DIR)/tex_unit
DPI_DIR := dpi

#     FPNEW 
FPNEW_DIR := ../third_party/fpnew/src
 # COMMON CELLS 
COMMON_CELL_DIR := $(FPNEW_DIR)/common_cells/src

# AHB
AHB_DIR := $(RTL_DIR)/ahb
AHB_INTF_DIR := $(AHB_DIR)/ahb_if
AHB_INTF_FILES := $(wildcard $(AHB_INTF_DIR)/*.sv)
AHB_RTL_FILES := $(AHB_DIR)/ahb_manager/src/ahb_manager.sv

INCL := 
INCL := include

#Interface files 
INTF_FILES := 
INTF_FILES += $(wildcard $(INTERFACES_DIR)/*.sv)

#FPNEW files 
FPNEW_FILES :=
FPNEW_FILES += $(wildcard $(FPNEW_DIR)/*.sv)

FPNEW_FILES += $(wildcard $(COMMON_CELL_DIR)/*.sv)

#FPNEW PKG
FPNEW_PKG := $(FPNEW_DIR)/fpnew_pkg.sv
FPNEW_PKG += $(wildcard $(COMMON_CELL_DIR)/*_pkg.sv)

#COMMON CELLS INC 
COMMON_CELL_INC := $(FPNEW_DIR)/common_cells/include

#FPU DIV
FPU_DIV_DIR := $(FPNEW_DIR)/fpu_div_sqrt_mvp/hdl
FPU_DIV_FILES := $(wildcard $(FPU_DIV_DIR)/*.sv)
FPU_DIV_PKG := $(FPU_DIV_DIR)/defs_div_sqrt_mvp.sv

#Design files 
RTL_FILES := 
#RTL_FILES += $(wildcard $(AFU_DIR)/*.sv)
RTL_FILES += $(wildcard $(CACHE_DIR)/*.sv)
RTL_FILES += $(wildcard $(FP_CORE_DIR)/*.sv)
RTL_FILES += $(wildcard $(LIBS_DIR)/*.sv)
RTL_FILES += $(wildcard $(TEXT_UNIT_DIR)/*.sv)

RTL_FILES += $(wildcard $(RTL_DIR)/*.sv)

# DPI DIR

# DPI_FILES := $(wildcard dpi/*.vh)
# DPI_INC := $(wildcard ../sim/common/*.h)
# DPI_INC += $(wildcard ../third_party/cocogfx/include/*.h)
# DPI_FILES += $(wildcard ../third_party/cocogfx/src/*)
# DPI_FILES += $(wildcard ../third_party/softbloat/src/*.c)
# DPI_INC += $(wildcard ../third_party/softbloat/src/include/*.h)
# DPI_FILES += $(wildcard dpi/*.cpp)
# DPI_FILES += $(wildcard ../sim/common/*.cpp)

WORKDIR := work

# Compiler/simulator options
VSIMOPTS := -lib $(WORKDIR) $(SIM_UI_OPT)
VLOGOPTS := -sv -work $(WORKDIR) -incr -vopt +define+SYNTHESIS +define+FPU_FPNEW 

# Note: C-functions in SV 
#VLOGOPTS_DPI := -dpiheader dpi_header_file.h -dpicpppath /usr/bin/g++ -ccflags "-std=c++11 -Wall -Wextra -Wfatal-errors" +define+UTIL_DPI +define+FLOAT_DPI

all: $(WORKDIR) compile run 

compile: $(WORKDIR)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(INTF_FILES) 
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(AHB_INTF_FILES)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(AHB_RTL_FILES)
		@vlog $(VLOGOPTS) +incdir+$(INCL) +incdir+$(COMMON_CELL_INC) +incdir+$(COMMON_CELL_DIR) $(FPNEW_FILES)
		@vlog $(VLOGOPTS) +incdir+$(FPU_DIV_DIR) $(FPU_DIV_FILES)
		@vlog $(VLOGOPTS) +incdir+$(INCL) +incdir+$(FPNEW_DIR) +incdir+$(FPU_DIV_DIR) +incdir+$(DPI_DIR) $(RTL_FILES)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(TARGET_TB)

run:
		vsim $(VSIMOPTS) \
		$(VX_TB) \
		-coverage \
		-do "run -all" 

$(WORKDIR):
	@vlib $(WORKDIR)

clean: 
	rm -rf work $(WORKDIR) transcript *.vstf 
	rm *.wlf


# RTL_DIR=./rtl
# SCRIPT_DIR=./scripts

# all: VX_config.h

# VX_config.h: $(RTL_DIR)/VX_config.vh	 
# 	$(SCRIPT_DIR)/gen_config.py -i $(RTL_DIR)/VX_config.vh -o VX_config.h

# clean:
# 	rm -f VX_config.h

# .PHONY: VX_config.h