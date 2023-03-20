
# Simulating VX on Questa

First, make sure that all submodules are available. If not, run from main directory: 
```
git submodule update --init --recursive

```

Then go back to /hw directory and make changes to the Makefile if needed. The current macros for successful simulation are:  

* SYNTHESIS: Uses synthesizable constructs 
* FPU_FPNEW: Uses the FPNEW Floating-Point Unit

Optional macros: 

* VX_TOP_TRACE: Top-level VX memory transaction trace to a logfile


Run
```
make all or make all_gui

```
  
