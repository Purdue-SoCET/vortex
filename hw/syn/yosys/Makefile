PROJECT = Vortex
TOP_LEVEL_ENTITY = VX_vortex_local_mem
SRC_FILE = VX_vortex_local_mem.sv
RTL_DIR = ../../rtl

DEFINES = -DNDEBUG -DSYNTHESIS -DEXT_F_DISABLE -DNUM_CORES=1 -DNUM_THREADS=2 -DNUM_WARPS=2 -DMEM_BLOCK_SIZE=64

RTL_INCLUDE = -I$(RTL_DIR) -I$(RTL_DIR)/libs -I$(RTL_DIR)/interfaces -I$(RTL_DIR)/cache -I$(RTL_DIR)/fp_cores -I$(RTL_DIR)/ahb/pkg -I$(RTL_DIR)/../../third_party/fpnew/src -I$(RTL_DIR)/../../third_party/fpnew/src/fpu_div_sqrt_mvp/hdl -I$(RTL_DIR)/../../third_party/fpnew/src/common_cells/include/common_cells
# Build targets
all: build

output.v:
	./sv2v.sh $(DEFINES) $(RTL_INCLUDE) -ooutput.v

build: output.v	
	./synth.sh -t$(TOP_LEVEL_ENTITY) -soutput.v

clean:
	rm -rf output.v *.ys *.log
