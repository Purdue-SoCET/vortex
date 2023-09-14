onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Vortex /VX_ahb_local_mem_tb/DUT/clk
add wave -noupdate -expand -group Vortex /VX_ahb_local_mem_tb/DUT/reset
add wave -noupdate -expand -group Vortex /VX_ahb_local_mem_tb/DUT/mem_req_valid
add wave -noupdate -expand -group Vortex /VX_ahb_local_mem_tb/DUT/mem_req_rw
add wave -noupdate -expand -group Vortex /VX_ahb_local_mem_tb/DUT/mem_req_byteen
add wave -noupdate -expand -group Vortex /VX_ahb_local_mem_tb/DUT/mem_req_addr
add wave -noupdate -expand -group Vortex /VX_ahb_local_mem_tb/DUT/mem_req_data
add wave -noupdate -expand -group Vortex /VX_ahb_local_mem_tb/DUT/mem_req_tag
add wave -noupdate -expand -group Vortex /VX_ahb_local_mem_tb/DUT/mem_req_ready
add wave -noupdate -expand -group Vortex /VX_ahb_local_mem_tb/DUT/mem_rsp_valid
add wave -noupdate -expand -group Vortex /VX_ahb_local_mem_tb/DUT/mem_rsp_data
add wave -noupdate -expand -group Vortex /VX_ahb_local_mem_tb/DUT/mem_rsp_tag
add wave -noupdate -expand -group Vortex /VX_ahb_local_mem_tb/DUT/mem_rsp_ready
add wave -noupdate -expand -group Vortex /VX_ahb_local_mem_tb/DUT/busy
add wave -noupdate -expand -group Vortex /VX_ahb_local_mem_tb/DUT/fp
add wave -noupdate -expand -group {ahb master} /VX_ahb_local_mem_tb/ahb_adapter/clk
add wave -noupdate -expand -group {ahb master} /VX_ahb_local_mem_tb/ahb_adapter/reset
add wave -noupdate -expand -group {ahb master} /VX_ahb_local_mem_tb/ahb_adapter/mem_req_valid
add wave -noupdate -expand -group {ahb master} /VX_ahb_local_mem_tb/ahb_adapter/mem_req_rw
add wave -noupdate -expand -group {ahb master} /VX_ahb_local_mem_tb/ahb_adapter/mem_req_byteen
add wave -noupdate -expand -group {ahb master} /VX_ahb_local_mem_tb/ahb_adapter/mem_req_addr
add wave -noupdate -expand -group {ahb master} /VX_ahb_local_mem_tb/ahb_adapter/mem_req_data
add wave -noupdate -expand -group {ahb master} /VX_ahb_local_mem_tb/ahb_adapter/mem_req_tag
add wave -noupdate -expand -group {ahb master} /VX_ahb_local_mem_tb/ahb_adapter/mem_rsp_ready
add wave -noupdate -expand -group {ahb master} /VX_ahb_local_mem_tb/ahb_adapter/mem_rsp_valid
add wave -noupdate -expand -group {ahb master} /VX_ahb_local_mem_tb/ahb_adapter/mem_rsp_data
add wave -noupdate -expand -group {ahb master} /VX_ahb_local_mem_tb/ahb_adapter/mem_rsp_tag
add wave -noupdate -expand -group {ahb master} /VX_ahb_local_mem_tb/ahb_adapter/mem_req_ready
add wave -noupdate -expand -group {ahb master} /VX_ahb_local_mem_tb/ahb_adapter/HREADY
add wave -noupdate -expand -group {ahb master} /VX_ahb_local_mem_tb/ahb_adapter/HRESP
add wave -noupdate -expand -group {ahb master} /VX_ahb_local_mem_tb/ahb_adapter/HRDATA
add wave -noupdate -expand -group {ahb master} /VX_ahb_local_mem_tb/ahb_adapter/HWRITE
add wave -noupdate -expand -group {ahb master} /VX_ahb_local_mem_tb/ahb_adapter/HTRANS
add wave -noupdate -expand -group {ahb master} /VX_ahb_local_mem_tb/ahb_adapter/HSIZE
add wave -noupdate -expand -group {ahb master} /VX_ahb_local_mem_tb/ahb_adapter/HADDR
add wave -noupdate -expand -group {ahb master} /VX_ahb_local_mem_tb/ahb_adapter/HWDATA
add wave -noupdate -expand -group {ahb master} /VX_ahb_local_mem_tb/ahb_adapter/HWSTRB
add wave -noupdate -expand -group {ahb master} /VX_ahb_local_mem_tb/ahb_adapter/HSEL
add wave -noupdate -expand -group {AHB slave (local_mem)} /VX_ahb_local_mem_tb/AHB_SLAVE/state
add wave -noupdate -expand -group {AHB slave (local_mem)} /VX_ahb_local_mem_tb/AHB_SLAVE/addr_d
add wave -noupdate -expand -group {AHB slave (local_mem)} /VX_ahb_local_mem_tb/AHB_SLAVE/sel_d
add wave -noupdate -expand -group {AHB slave (local_mem)} /VX_ahb_local_mem_tb/AHB_SLAVE/burst_d
add wave -noupdate -expand -group {AHB slave (local_mem)} /VX_ahb_local_mem_tb/AHB_SLAVE/write_d
add wave -noupdate -expand -group {AHB slave (local_mem)} /VX_ahb_local_mem_tb/AHB_SLAVE/trans_d
add wave -noupdate -expand -group {AHB slave (local_mem)} /VX_ahb_local_mem_tb/AHB_SLAVE/size_d
add wave -noupdate -expand -group {AHB slave (local_mem)} /VX_ahb_local_mem_tb/AHB_SLAVE/hreadyout_d
add wave -noupdate -expand -group {AHB slave (local_mem)} /VX_ahb_local_mem_tb/AHB_SLAVE/decoded_addr
add wave -noupdate -expand -group {AHB slave (local_mem)} /VX_ahb_local_mem_tb/AHB_SLAVE/range_error
add wave -noupdate -expand -group {AHB slave (local_mem)} /VX_ahb_local_mem_tb/AHB_SLAVE/align_error
add wave -noupdate -expand -group {AHB slave (local_mem)} /VX_ahb_local_mem_tb/AHB_SLAVE/addr_error
add wave -noupdate -group Local_mem /VX_ahb_local_mem_tb/MEM/VORTEX_START_PC_ADDR
add wave -noupdate -group Local_mem /VX_ahb_local_mem_tb/MEM/VORTEX_LOCAL_MEM_AHB_BASE_ADDR
add wave -noupdate -group Local_mem /VX_ahb_local_mem_tb/MEM/LOCAL_MEM_SIZE
add wave -noupdate -group Local_mem /VX_ahb_local_mem_tb/MEM/clk
add wave -noupdate -group Local_mem /VX_ahb_local_mem_tb/MEM/reset
add wave -noupdate -group Local_mem /VX_ahb_local_mem_tb/MEM/mem_req_valid
add wave -noupdate -group Local_mem /VX_ahb_local_mem_tb/MEM/mem_req_rw
add wave -noupdate -group Local_mem /VX_ahb_local_mem_tb/MEM/mem_req_byteen
add wave -noupdate -group Local_mem /VX_ahb_local_mem_tb/MEM/mem_req_addr
add wave -noupdate -group Local_mem /VX_ahb_local_mem_tb/MEM/mem_req_data
add wave -noupdate -group Local_mem /VX_ahb_local_mem_tb/MEM/mem_req_tag
add wave -noupdate -group Local_mem /VX_ahb_local_mem_tb/MEM/mem_req_ready
add wave -noupdate -group Local_mem /VX_ahb_local_mem_tb/MEM/mem_rsp_valid
add wave -noupdate -group Local_mem /VX_ahb_local_mem_tb/MEM/mem_rsp_data
add wave -noupdate -group Local_mem /VX_ahb_local_mem_tb/MEM/mem_rsp_tag
add wave -noupdate -group Local_mem /VX_ahb_local_mem_tb/MEM/mem_rsp_ready
add wave -noupdate -group Local_mem /VX_ahb_local_mem_tb/MEM/busy
add wave -noupdate -group Local_mem /VX_ahb_local_mem_tb/MEM/Vortex_bad_address
add wave -noupdate -group Local_mem /VX_ahb_local_mem_tb/MEM/AHB_bad_address
add wave -noupdate -group Local_mem /VX_ahb_local_mem_tb/MEM/reg_file
add wave -noupdate -group Local_mem /VX_ahb_local_mem_tb/MEM/next_reg_file
add wave -noupdate -group {per cluster} /VX_ahb_local_mem_tb/DUT/per_cluster_mem_req_valid
add wave -noupdate -group {per cluster} /VX_ahb_local_mem_tb/DUT/per_cluster_mem_req_rw
add wave -noupdate -group {per cluster} /VX_ahb_local_mem_tb/DUT/per_cluster_mem_req_byteen
add wave -noupdate -group {per cluster} /VX_ahb_local_mem_tb/DUT/per_cluster_mem_req_addr
add wave -noupdate -group {per cluster} /VX_ahb_local_mem_tb/DUT/per_cluster_mem_req_data
add wave -noupdate -group {per cluster} /VX_ahb_local_mem_tb/DUT/per_cluster_mem_req_tag
add wave -noupdate -group {per cluster} /VX_ahb_local_mem_tb/DUT/per_cluster_mem_req_ready
add wave -noupdate -group {per cluster} /VX_ahb_local_mem_tb/DUT/per_cluster_mem_rsp_valid
add wave -noupdate -group {per cluster} /VX_ahb_local_mem_tb/DUT/per_cluster_mem_rsp_data
add wave -noupdate -group {per cluster} /VX_ahb_local_mem_tb/DUT/per_cluster_mem_rsp_tag
add wave -noupdate -group {per cluster} /VX_ahb_local_mem_tb/DUT/per_cluster_mem_rsp_ready
add wave -noupdate -group {per cluster} /VX_ahb_local_mem_tb/DUT/per_cluster_busy
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10439305 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 238
configure wave -valuecolwidth 185
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
WaveRestoreZoom {0 ps} {31527300 ps}
