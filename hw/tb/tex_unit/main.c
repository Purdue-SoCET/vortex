//Author: Raghul Prakash
//Description: TU setup
#include "./include/vx_intrinsics.h"
#include "./include/vx_spawn.h"

int main(){
  //set up tu
  csr_write(CSR_TEX_UNIT, 1);
  csr_write(CSR_TEX_ADDR, image_file); //image address
	csr_write(CSR_TEX_WIDTH, 64); //image address
  csr_write(CSR_TEX_HEIGHT, 64); //image address
  csr_write(CSR_TEX_FORMAT, TEX_FORMAT_R5G6B5); //format of image
  
	return 0;
}
