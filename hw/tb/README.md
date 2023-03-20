# Loading Vortex_mem_slave.sv with corresponding hex file data

### load_Vortex_mem_slave.py
script to create Vortex_mem_slave.sv source file for given .hex file which interfaces directly with Vortex memory interfacing signals and AHB slave interfacing signals

- commandline (from inside /tb directory):  
``python3 load_Vortex_mem_slave.py <.hex file name> <optional flags>``  

- flags:  
  - ``-p``: print debugging info

# Loading local_mem.sv with corresponding hex file data

### load_local_mem.py
script to create local_mem.sv source file for given .hex file which interfaces directly with Vortex memory interfacing signals to simulate a local memory

- commandline (from inside /tb directory):  
``python3 load_local_mem.py <.hex file name> <optional flags>``  

- flags:  
  - ``-p``: print debugging info
