onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /VX_local_mem_tb/clk
add wave -noupdate /VX_local_mem_tb/reset
add wave -noupdate -divider {Vortex Signals}
add wave -noupdate -expand -group Vortex -divider Inputs
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_req_ready
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_rsp_valid
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_rsp_data
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_rsp_tag
add wave -noupdate -expand -group Vortex -divider Outputs
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_req_valid
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_req_rw
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_req_byteen
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_req_addr
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_req_data
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_req_tag
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/mem_rsp_ready
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/busy
add wave -noupdate -divider MEM
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {934 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 238
configure wave -valuecolwidth 289
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
WaveRestoreZoom {678 ps} {1115 ps}
