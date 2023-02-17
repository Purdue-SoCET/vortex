# RAM_FAKE
RAM_FAKE_DEF := ram_fake_reg_file.vh
RAM_FAKE_RTL_FILES := reg_file.sv ram_fake_reg_file.sv 
RAM_FAKE_TB := ram_fake_reg_file_tb.sv

INCL := 
INCL := include

WORKDIR := work

# Compiler/simulator options
VSIMOPTS := -lib $(WORKDIR) 
VLOGOPTS := -sv -work $(WORKDIR) -incr -vopt +define+SYNTHESIS #+define+SYNTHESIS
# VLOGOPTS_DPI := -sv -work $(WORKDIR) -dpiheader dpi_header_file.h -dpicpppath /usr/bin/g++ -ccflags "-std=c++11 -Wall -Wextra -Wfatal-errors" +define+UTIL_DPI +define+FLOAT_DPI
# VLOGOPTS_DPI_CPP := -work $(WORKDIR) -dpicpppath /usr/bin/g++ -ccflags "-std=c++11 -Wall -Wextra -Wfatal-errors"


all: $(WORKDIR) compile run 

compile: $(WORKDIR)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(RAM_FAKE_DEF)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(RAM_FAKE_RTL_FILES)
		@vlog $(VLOGOPTS) +incdir+$(INCL) $(RAM_FAKE_TB)

run:
		vsim $(VSIMOPTS) -c \
		ram_fake_reg_file_tb \
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