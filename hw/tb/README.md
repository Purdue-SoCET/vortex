# Loading Vortex_mem_slave.sv with corresponding hex file data

### load_Vortex_mem_slave.py
script to create Vortex_mem_slave.sv source file for given .hex file which interfaces directly with Vortex memory interfacing signals and AHB slave interfacing signals

- commandline (from inside /tb directory):  
``python3 load_Vortex_mem_slave.py <.hex file name> <optional flags>``  

- flags:  
  - ``-zero``: reset all registers to 0 instead of corresponding hex file values
  - ``-p``: print debugging info
  - ``-size <n bits to represent size, 2^n>``: change the size of the local mem
  
shortcut usage which doesn't 

### simulating Vortex_mem_slave.sv

- commandline (from inside /tb directory):
  - sim without waves  
  ``make Vortex_mem_slave.sim``
  - sim with waves  
  ``make Vortex_mem_slave.wav``

# Loading local_mem.sv with corresponding hex file data

### load_local_mem.py
script to create local_mem.sv source file for given .hex file which interfaces directly with Vortex memory interfacing signals to simulate a local memory

- commandline (from inside /tb directory):  
``python3 load_local_mem.py <.hex file name> <optional flags>``  

- flags:  
  - ``-p``: print debugging info
