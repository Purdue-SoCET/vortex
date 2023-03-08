//author: Raghul Prakash
//AFTx Vortex program interfacing library
//ADDR: start register 0xFFFF
//ADDR: status register 0XFFFFF
#define START_BASE 0xFFFF
#define STATUS_BASE 0xFFFFF
#define LOCAL_SRAM_BASE 0xFFFFFF
#define LOCAL_SRAM_SIZE 0xFFF

uint32_t * start_reg = (uint32_t *) START_BASE;
uint32_t * status_reg = (uint32_t *) STATUS_BASE;
uint32_t * sram_base_reg = (uint32_t *) LOCAL_SRAM_BASE;

//start vortex
uint32_t vx_start(){
	*start_reg = 1;
	return 0;
}

//status polling 
uint32_t vx_status(){
	return *status_reg;
}

//write hex to local sram
uint32_t vx_write(uint32_t * data, int size){
	if (size > LOCAL_SRAM_SIZE) return -1;
	for (int i = 0; i < size; i++){
		*((uint8_t)sram_base_reg + i) = *((uint8_t)data + i);
	}
}


