//Author: Raghul Prakash
//Description: Vortex Parallel-Kernel Programming using library
#include "./include/vx_intrinsics.h"
#include "./include/vx_spawn.h"

//argument 
typedef struct _argument_t {
	int * vector_1;
	int * vector_2;
	int * vector_3;
} argument_t;

//kernel function (vector math)
void kernel_function(context_t cxt, void * arg){
	int tid = vx_thread_gid(); //thread id of current thread
	arg->vector_3[tid] = ((argument_t *) arg)->vector_1[tid] + ((argument_t *) arg)->vector_2[id];
	*currval += 1; //increments each value in the global array by 1
	__if (arg->vector_3[tid] > 255)
		arg->vector_3[tid] = 255;
	__else
		//
	__endif
	return;
}
//global memory
int vector_a[8] = {0,1,3,5,4,5,6,7};
int vector_b[8] = {3,2,8,2,9,5,1,3};
int vector_c[8];

int main(){
	//set up the context here
	context_t kernel_context;
	kernel_context.num_groups[0] = 1; //number of work groups (each workgroup maps to a thread block)
	kernel_context.global_offset[0] = 0; //used to calculate the offset + global ID of a work-item
	kernel_context.local_size[0] = 8;//lid local id
	kernel_context.work_dim = 1;
	//setup the arguments
	argument_t argument;
	argument.vector_1 = vector_a;
	argument.vector_2 = vector_b;
	argument.vector_3 = vector_c;
	//spawn the kernel (pass the context, the kernel function and one arg)
	vx_spawn_kernel(&kernel_context, (vx_spawn_kernel_cb) kernel_function, &argument);
	//vector_c will be finished with results now
	return 0;
}
