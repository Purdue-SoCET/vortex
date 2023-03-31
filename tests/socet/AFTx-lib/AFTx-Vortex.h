//author: Raghul Prakash
//AFTx Vortex program interfacing library
//ADDR: start register 0xFFFF
//ADDR: status register 0XFFFFF
#include <stdint.h>
#include "pal.h"

//start vortex
void vx_start(){
	((VortexRegBlk *)vortex)->start = 0x1;
	return;
}

//status polling 
void vx_status(){
	while (!((VortexRegBlk *)vortex)->status);
	return;
}

//write hex to local sram
int vx_copy(uint32_t * src_data, uint32_t * dest_data, int size){
	for (int i = 0; i < size; i++){
		*((uint8_t)dest_data + i) = *((uint8_t)src_data + i);
	}
	return;
}


