
#include "../intrinsics/vx_intrinsics.h"
#include "vx_api.h"
#include <inttypes.h>

#ifdef __cplusplus
extern "C" {
#endif


func_t global_function_pointer;
// void (func_t)(void *)

void *   global_argument_struct;

unsigned global_num_threads;
void setup_call()
{
	vx_tmc(global_num_threads);
	global_function_pointer(global_argument_struct);

	unsigned wid = vx_warpID();
	if (wid != 0)
	{
		vx_tmc(0); // Halt Warp Execution
	}
	else
	{
		vx_tmc(1); // Only activate one thread
	}
}

void vx_spawnWarps(unsigned numWarps, unsigned numThreads, func_t func_ptr, void * args)
{
	global_function_pointer = func_ptr;
	global_argument_struct  = args;
	global_num_threads      = numThreads;
	vx_wspawn(numWarps, (unsigned) setup_call);
	setup_call();

}

void pocl_spawn(context_t * ctx, const void * pfn, void * arguments)
{

   vx_pocl_workgroup_func use_pfn = (vx_pocl_workgroup_func) pfn;
   int z;
   int y;
   int x;
	for (z = 0; z < ctx->num_groups[2]; ++z)
	{
		for (y = 0; y < ctx->num_groups[1]; ++y)
		{
			for (x = 0; x < ctx->num_groups[0]; ++x)
			{
				(use_pfn)((uint8_t *)arguments, (uint8_t *)ctx, x, y, z);
			}
		}
	}
}

#ifdef __cplusplus
}
#endif
