onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /VX_local_mem_tb/clk
add wave -noupdate /VX_local_mem_tb/reset
add wave -noupdate -divider {Vortex Signals}
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_req_valid
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_req_rw
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_req_byteen
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_req_addr
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_req_data
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_req_tag
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_req_ready
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_rsp_valid
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_rsp_data
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_rsp_tag
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_rsp_ready
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/busy
add wave -noupdate -divider MEM
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/mem_req_valid
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/mem_req_rw
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/mem_req_byteen
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/mem_req_addr
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/mem_req_data
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/mem_req_tag
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/mem_req_ready
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/mem_rsp_valid
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/mem_rsp_data
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/mem_rsp_tag
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/mem_rsp_ready
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/busy
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/tb_addr_out_of_bounds
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/wen_0_80000000
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/wsel_0_80000000
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/wdata_0_80000000
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/rsel_0_80000000
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/rdata_0_80000000
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/reg_val_0_80000000
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/next_reg_val_0_80000000
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/wen_1_80001000
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/wsel_1_80001000
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/wdata_1_80001000
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/rsel_1_80001000
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/rdata_1_80001000
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/reg_val_1_80001000
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/next_reg_val_1_80001000
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/chunk_sel
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {19642 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 238
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {120657 ps}
