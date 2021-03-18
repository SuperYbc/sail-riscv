# Makefile for program model example

XLEN ?= 64

default: all

src_dir = ./gengen_src/outputs
common_dir = common
env_dir = env


#--------------------------------------------------------------------
# Sources
#--------------------------------------------------------------------

ALL_TEST = $(basename $(notdir $(wildcard $(src_dir)/*.c)))
OBJECTS ?= $(ALL_TEST)

#--------------------------------------------------------------------
# Build rules
#--------------------------------------------------------------------
SAIL_PATH = ../..
SAIL_C_EMULATOR = $(SAIL_PATH)/c_emulator/riscv_sim_RV64
RISCV_PREFIX ?= riscv$(XLEN)-unknown-elf-
RISCV_GCC ?= $(RISCV_PREFIX)gcc
RISCV_GCC_OPTS ?= -DPREALLOCATE=1 -mcmodel=medany -static -std=gnu99 -O2 -ffast-math -fno-common -fno-builtin-printf -fno-tree-loop-distribute-patterns
RISCV_LINK ?= $(RISCV_GCC) -T $(common_dir)/test.ld $(incs)
RISCV_LINK_OPTS ?= -static -nostdlib -nostartfiles -lm -lgcc -T $(common_dir)/test.ld
RISCV_OBJDUMP ?= $(RISCV_PREFIX)objdump --disassemble-all --disassemble-zeroes --section=.text --section=.text.startup --section=.text.init --section=.data
RISCV_SIM ?= spike --isa=rv$(XLEN)gc

incs  += -I$(env_dir) -I$(common_dir)
objs  := build

$(OBJECTS):
	mkdir -p $(objs)
	$(RISCV_GCC) $(incs) $(RISCV_GCC_OPTS) $(src_dir)/$@.c $(common_dir)/*.c $(common_dir)/*.S $(RISCV_LINK_OPTS) -o $(objs)/$@.riscv
	$(SAIL_C_EMULATOR) --enable-pmp --enable-spmp -V $(objs)/$@.riscv >> result.log 

#------------------------------------------------------------
# Build and run benchmarks on riscv simulator

riscv_bin  = *.riscv
riscv_dump = *.riscv.dump
riscv_out  = *.riscv.out
riscv_log  = *.log


junk += $(riscv_bin) $(riscv_dump) $(riscv_out) $(riscv_log)

#------------------------------------------------------------
# Targets

gen:
	cd gengen_src; $(MAKE); $(MAKE) gen;

all: $(OBJECTS) 
	

#------------------------------------------------------------
# Clean up

clean:
	rm -rf $(objs) $(junk) 
