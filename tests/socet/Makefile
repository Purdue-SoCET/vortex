XLEN ?= 32

ifeq ($(XLEN),32)
RISCV_TOOLCHAIN_PATH = ${DESTDIR}/riscv-gnu-toolchain
else
RISCV_TOOLCHAIN_PATH = ${DESTDIR}/riscv64-gnu-toolchain
endif

RISCV_PREFIX ?= riscv$(XLEN)-unknown-elf-

CC = $(RISCV_PREFIX)gcc
AR = $(RISCV_PREFIX)gcc-ar
DP = $(RISCV_PREFIX)objdump
CP = $(RISCV_PREFIX)objcopy


ifeq ($(XLEN),32)
CFLAGS += -march=rv32imf -mabi=ilp32f
else
CFLAGS += -march=rv64imfd -mabi=lp64d
endif

CFLAGS += -O3 -Wstack-usage=1024 -mcmodel=medany -ffreestanding -nostartfiles -fdata-sections -ffunction-sections
CFLAGS += -Iinclude 

LDFLAGS += -lm -Wl,-Bstatic,-T,./linker/vx_link$(XLEN).ld -fno-use-linker-plugin 
PROJECT = simple

SRCS = main.c ./include/vx_start.S ./include/vx_syscalls.c ./include/vx_spawn.c ./include/vx_spawn.S ./include/vortex.cpp


all: $(PROJECT).elf $(PROJECT).bin $(PROJECT).dump $(PROJECT).hex

$(PROJECT).dump: $(PROJECT).elf
	$(DP) -D $(PROJECT).elf > $(PROJECT).dump

$(PROJECT).bin: $(PROJECT).elf
	$(CP) -O binary $(PROJECT).elf $(PROJECT).bin

$(PROJECT).elf: $(SRCS)
	$(CC) $(CFLAGS) $(SRCS) $(LDFLAGS) -o $(PROJECT).elf

$(PROJECT).hex: $(PROJECT).elf
	$(CP) -O ihex $(PROJECT).elf $(PROJECT).hex

.depend: $(SRCS)
	$(CC) $(CFLAGS) -MM $^ > .depend;

clean:
	rm -rf *.hex *.elf *.bin *.dump .depend 
