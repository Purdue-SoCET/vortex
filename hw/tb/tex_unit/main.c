//Author: Raghul Prakash
//Description: TU setup and read
#include "./include/vx_intrinsics.h"
#include "./include/vx_spawn.h"

int main(){
  //set up tu
  csr_write(CSR_TEX_UNIT, 1);
  csr_write(CSR_TEX_ADDR, image_file); //image address
  csr_write(CSR_TEX_WIDTH, 64); //image size
  csr_write(CSR_TEX_HEIGHT, 64); //image size
  csr_write(CSR_TEX_FORMAT, TEX_FORMAT_R5G6B5); //format of image
  //get data
  uint32_t result = vx_tex(1, 0.1f, 0.1f, 1);
  return 0;
}
