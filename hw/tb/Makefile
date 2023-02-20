# LOCAL_MEM
LOCAL_MEM_DEF := local_mem.vh
LOCAL_MEM_RTL_FILES := local_mem.sv 
LOCAL_MEM_TB := local_mem_tb.sv

# DIR's
INCL := 
INCL := include
WORKDIR := work
SCRDIR			= scripts

# others hard defined
SIMTIME := -all

# view waveform in graphical mode and load do file if there is one
DOFILE 				= local_mem
WAVDO				= do $(SCRDIR)/$(DOFILE).do
SIMDO				= "view objects; $(WAVDO); run $(SIMTIME);" -onfinish stop

# SIM_UI_OPT := -gui
# SIM_UI_OPT := -c

# Compiler/simulator options
VSIMOPTS := -lib $(WORKDIR)
VLOGOPTS := -sv -work $(WORKDIR) -incr -vopt +define+SYNTHESIS #+define+SYNTHESIS
# VLOGOPTS_DPI := -sv -work $(WORKDIR) -dpiheader dpi_header_file.h -dpicpppath /usr/bin/g++ -ccflags "-std=c++11 -Wall -Wextra -Wfatal-errors" +define+UTIL_DPI +define+FLOAT_DPI
# VLOGOPTS_DPI_CPP := -work $(WORKDIR) -dpicpppath /usr/bin/g++ -ccflags "-std=c++11 -Wall -Wextra -Wfatal-errors"


compile: $(WORKDIR)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(LOCAL_MEM_DEF)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(LOCAL_MEM_RTL_FILES)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(LOCAL_MEM_TB)

local_mem.wav: compile
		vsim $(VSIMOPTS) -gui \
		local_mem_tb \
		-coverage -voptargs=+acc \
		-do $(SIMDO)

local_mem.sim: compile
		vsim $(VSIMOPTS) -c \
		local_mem_tb \
		-coverage \
		-do "run $(SIMTIME);"

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
