//Author: Raghul Prakash
//Description: Vortex Parallel-Kernel Programming using library
#include "./include/vx_intrinsics.h"
#include "./include/vx_spawn.h"


//kernel function 
int kernel_function(context_t cxt, void * arg){
	int tid = vx_thread_id();
	int a = 3;
	int b = 4;
	a = b + a + 3;
	a += ((int *)arg)[tid];
	return 0;
}

int main(){
	//set up the context here
	context_t kernel_context;
	kernel_context.num_groups[0] = 4;
	kernel_context.global_offset[0] = 4;//gid
	kernel_context.local_size[0] = 4;//lid
	kernel_context.printf_buffer = NULL;
	kernel_context.work_dim = 1;
	
	//kernel arg
	int global_buffer[64];
	
	//spawn the kernel (pass the context, the kernel function and one arg)
	vx_spawn_kernel(&kernel_context, (vx_spawn_kernel_cb) kernel_function, global_buffer);

	//vx_tmc(-1);
	return 0;
}
