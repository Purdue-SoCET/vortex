# LOCAL_MEM
LOCAL_MEM_DEF := local_mem.vh
LOCAL_MEM_RTL_FILES := local_mem.sv 
LOCAL_MEM_TB := local_mem_tb.sv

# VORTEX_MEM_SLAVE
VORTEX_MEM_SLAVE_DEF := Vortex_mem_slave.vh
VORTEX_MEM_SLAVE_RTL_FILES := Vortex_mem_slave.sv 
VORTEX_MEM_SLAVE_TB := Vortex_mem_slave_tb.sv

# DIR's
INCL := 
INCL := include
WORKDIR := work
SCRDIR			= scripts

# others hard defined
SIMTIME := -all

# view waveform in graphical mode and load do file if there is one
LOCAL_MEM_DOFILE 		= local_mem
LOCAL_MEM_WAVDO			= do $(SCRDIR)/$(LOCAL_MEM_DOFILE).do
LOCAL_MEM_SIMDO			= "view objects; $(LOCAL_MEM_WAVDO); run $(SIMTIME);" -onfinish stop

VORTEX_MEM_SLAVE_DOFILE	= Vortex_mem_slave
VORTEX_MEM_SLAVE_WAVDO	= do $(SCRDIR)/$(VORTEX_MEM_SLAVE_DOFILE).do
VORTEX_MEM_SLAVE_SIMDO	= "view objects; $(VORTEX_MEM_SLAVE_WAVDO); run $(SIMTIME);" -onfinish stop

# SIM_UI_OPT := -gui
# SIM_UI_OPT := -c

# Compiler/simulator options
VSIMOPTS := -lib $(WORKDIR)
VLOGOPTS := -sv -work $(WORKDIR) -incr -vopt +define+SYNTHESIS #+define+SYNTHESIS
# VLOGOPTS_DPI := -sv -work $(WORKDIR) -dpiheader dpi_header_file.h -dpicpppath /usr/bin/g++ -ccflags "-std=c++11 -Wall -Wextra -Wfatal-errors" +define+UTIL_DPI +define+FLOAT_DPI
# VLOGOPTS_DPI_CPP := -work $(WORKDIR) -dpicpppath /usr/bin/g++ -ccflags "-std=c++11 -Wall -Wextra -Wfatal-errors"

# TARGETS:
%.load: load_Vortex_mem_slave.py
		python3 load_Vortex_mem_slave.py hex_files/$*


compile_local_mem: $(WORKDIR)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(LOCAL_MEM_DEF)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(LOCAL_MEM_RTL_FILES)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(LOCAL_MEM_TB)

local_mem.wav: compile_local_mem
		vsim $(VSIMOPTS) -gui \
		local_mem_tb \
		-coverage -voptargs=+acc \
		-do $(LOCAL_MEM_SIMDO)

local_mem.sim: compile_local_mem
		vsim $(VSIMOPTS) -c \
		local_mem_tb \
		-coverage \
		-do "run $(SIMTIME);"

compile_Vortex_mem_slave: $(WORKDIR)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(VORTEX_MEM_SLAVE_DEF)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(VORTEX_MEM_SLAVE_RTL_FILES)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(VORTEX_MEM_SLAVE_TB)

Vortex_mem_slave.wav: compile_Vortex_mem_slave
		vsim $(VSIMOPTS) -gui \
		Vortex_mem_slave_tb \
		-coverage -voptargs=+acc \
		-do $(VORTEX_MEM_SLAVE_SIMDO)

Vortex_mem_slave.sim: compile_Vortex_mem_slave
		vsim $(VSIMOPTS) -c \
		Vortex_mem_slave_tb \
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
