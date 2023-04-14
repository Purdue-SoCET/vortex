
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
  
  
# Using Trace File Scraper

Generate trace file from gold model C++ simulation by running rtlsim on local machine or virtual machine. See Vortex Software:  
https://wiki.itap.purdue.edu/display/ecedesign/Vortex+Software

Generate trace file from questa version by running:
```
make all
```

Use trace file scraper to compare rtlsim file and questa file:
```
python3 scrape_traces.py <rtlsim trace file> <questa trace file> <optional flags>
```
- flags:  
  - ``-p``: print debugging info
  - ``-out <output file name>: generate output file with name other than default, "trace_diff.log"``  

This script gives info about the difference between the two traces and generates simplified trace files which you can visually compare with tkdiff:
```
tkdiff <rtlsim trace file>.scrape.log <questa trace file>.scrape.log
```
