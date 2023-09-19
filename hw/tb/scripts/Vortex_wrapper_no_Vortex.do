onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Vortex_wrapper_no_Vortex_tb/clk
add wave -noupdate /Vortex_wrapper_no_Vortex_tb/nRST
add wave -noupdate -expand -group {TB Signals} /Vortex_wrapper_no_Vortex_tb/test_case
add wave -noupdate -expand -group {TB Signals} /Vortex_wrapper_no_Vortex_tb/sub_test_case
add wave -noupdate -expand -group {TB Signals} /Vortex_wrapper_no_Vortex_tb/num_errors
add wave -noupdate -expand -group {Vortex Wrapper Req Signals} -divider Inputs
add wave -noupdate -expand -group {Vortex Wrapper Req Signals} /Vortex_wrapper_no_Vortex_tb/Vortex_mem_req_valid
add wave -noupdate -expand -group {Vortex Wrapper Req Signals} /Vortex_wrapper_no_Vortex_tb/Vortex_mem_req_rw
add wave -noupdate -expand -group {Vortex Wrapper Req Signals} /Vortex_wrapper_no_Vortex_tb/Vortex_mem_req_byteen
add wave -noupdate -expand -group {Vortex Wrapper Req Signals} /Vortex_wrapper_no_Vortex_tb/Vortex_mem_req_addr
add wave -noupdate -expand -group {Vortex Wrapper Req Signals} /Vortex_wrapper_no_Vortex_tb/Vortex_mem_req_data
add wave -noupdate -expand -group {Vortex Wrapper Req Signals} /Vortex_wrapper_no_Vortex_tb/Vortex_mem_req_tag
add wave -noupdate -expand -group {Vortex Wrapper Req Signals} -divider Outputs
add wave -noupdate -expand -group {Vortex Wrapper Req Signals} /Vortex_wrapper_no_Vortex_tb/Vortex_mem_req_ready
add wave -noupdate -expand -group {Vortex Wrapper Req Signals} /Vortex_wrapper_no_Vortex_tb/expected_Vortex_mem_req_ready
add wave -noupdate -expand -group {Vortex Wrapper Rsp Signals} -divider Inputs
add wave -noupdate -expand -group {Vortex Wrapper Rsp Signals} /Vortex_wrapper_no_Vortex_tb/Vortex_mem_rsp_ready
add wave -noupdate -expand -group {Vortex Wrapper Rsp Signals} -divider Outputs
add wave -noupdate -expand -group {Vortex Wrapper Rsp Signals} /Vortex_wrapper_no_Vortex_tb/Vortex_mem_rsp_valid
add wave -noupdate -expand -group {Vortex Wrapper Rsp Signals} /Vortex_wrapper_no_Vortex_tb/expected_Vortex_mem_rsp_valid
add wave -noupdate -expand -group {Vortex Wrapper Rsp Signals} /Vortex_wrapper_no_Vortex_tb/Vortex_mem_rsp_data
add wave -noupdate -expand -group {Vortex Wrapper Rsp Signals} /Vortex_wrapper_no_Vortex_tb/expected_Vortex_mem_rsp_data
add wave -noupdate -expand -group {Vortex Wrapper Rsp Signals} /Vortex_wrapper_no_Vortex_tb/Vortex_mem_rsp_tag
add wave -noupdate -expand -group {Vortex Wrapper Rsp Signals} /Vortex_wrapper_no_Vortex_tb/expected_Vortex_mem_rsp_tag
add wave -noupdate -expand -group {Vortex Wrapper Status Signals} -divider Inputs
add wave -noupdate -expand -group {Vortex Wrapper Status Signals} /Vortex_wrapper_no_Vortex_tb/Vortex_busy
add wave -noupdate -expand -group {Vortex Wrapper Status Signals} -divider Outputs
add wave -noupdate -expand -group {Vortex Wrapper Status Signals} /Vortex_wrapper_no_Vortex_tb/Vortex_reset
add wave -noupdate -expand -group {Vortex Wrapper Status Signals} /Vortex_wrapper_no_Vortex_tb/expected_Vortex_reset
add wave -noupdate -expand -group {Vortex Wrapper Status Signals} /Vortex_wrapper_no_Vortex_tb/Vortex_PC_reset_val
add wave -noupdate -expand -group {Vortex Wrapper Status Signals} /Vortex_wrapper_no_Vortex_tb/expected_Vortex_PC_reset_val
add wave -noupdate -expand -group {Mem Slave BPIF} -divider Inputs
add wave -noupdate -expand -group {Mem Slave BPIF} /Vortex_wrapper_no_Vortex_tb/mem_slave_bpif/wen
add wave -noupdate -expand -group {Mem Slave BPIF} /Vortex_wrapper_no_Vortex_tb/mem_slave_bpif/ren
add wave -noupdate -expand -group {Mem Slave BPIF} /Vortex_wrapper_no_Vortex_tb/mem_slave_bpif/addr
add wave -noupdate -expand -group {Mem Slave BPIF} /Vortex_wrapper_no_Vortex_tb/mem_slave_bpif/strobe
add wave -noupdate -expand -group {Mem Slave BPIF} /Vortex_wrapper_no_Vortex_tb/mem_slave_bpif/wdata
add wave -noupdate -expand -group {Mem Slave BPIF} -divider Outputs
add wave -noupdate -expand -group {Mem Slave BPIF} /Vortex_wrapper_no_Vortex_tb/mem_slave_bpif/rdata
add wave -noupdate -expand -group {Mem Slave BPIF} /Vortex_wrapper_no_Vortex_tb/expected_mem_slave_bpif_rdata
add wave -noupdate -expand -group {Mem Slave BPIF} /Vortex_wrapper_no_Vortex_tb/mem_slave_bpif/error
add wave -noupdate -expand -group {Mem Slave BPIF} /Vortex_wrapper_no_Vortex_tb/expected_mem_slave_bpif_error
add wave -noupdate -expand -group {Mem Slave BPIF} /Vortex_wrapper_no_Vortex_tb/mem_slave_bpif/request_stall
add wave -noupdate -expand -group {Mem Slave BPIF} /Vortex_wrapper_no_Vortex_tb/expected_mem_slave_bpif_request_stall
add wave -noupdate -expand -group {CTRL/Status BPIF} -divider Inputs
add wave -noupdate -expand -group {CTRL/Status BPIF} /Vortex_wrapper_no_Vortex_tb/ctrl_status_bpif/wen
add wave -noupdate -expand -group {CTRL/Status BPIF} /Vortex_wrapper_no_Vortex_tb/ctrl_status_bpif/ren
add wave -noupdate -expand -group {CTRL/Status BPIF} /Vortex_wrapper_no_Vortex_tb/ctrl_status_bpif/addr
add wave -noupdate -expand -group {CTRL/Status BPIF} /Vortex_wrapper_no_Vortex_tb/ctrl_status_bpif/strobe
add wave -noupdate -expand -group {CTRL/Status BPIF} /Vortex_wrapper_no_Vortex_tb/ctrl_status_bpif/wdata
add wave -noupdate -expand -group {CTRL/Status BPIF} -divider Outputs
add wave -noupdate -expand -group {CTRL/Status BPIF} /Vortex_wrapper_no_Vortex_tb/ctrl_status_bpif/rdata
add wave -noupdate -expand -group {CTRL/Status BPIF} /Vortex_wrapper_no_Vortex_tb/expected_ctrl_status_bpif_rdata
add wave -noupdate -expand -group {CTRL/Status BPIF} /Vortex_wrapper_no_Vortex_tb/ctrl_status_bpif/error
add wave -noupdate -expand -group {CTRL/Status BPIF} /Vortex_wrapper_no_Vortex_tb/expected_ctrl_status_bpif_error
add wave -noupdate -expand -group {CTRL/Status BPIF} /Vortex_wrapper_no_Vortex_tb/ctrl_status_bpif/request_stall
add wave -noupdate -expand -group {CTRL/Status BPIF} /Vortex_wrapper_no_Vortex_tb/expected_ctrl_status_bpif_request_stall
add wave -noupdate -expand -group {AHB Manager AHBIF} -divider Inputs
add wave -noupdate -expand -group {AHB Manager AHBIF} /Vortex_wrapper_no_Vortex_tb/ahb_manager_ahbif/HCLK
add wave -noupdate -expand -group {AHB Manager AHBIF} /Vortex_wrapper_no_Vortex_tb/ahb_manager_ahbif/HRESETn
add wave -noupdate -expand -group {AHB Manager AHBIF} /Vortex_wrapper_no_Vortex_tb/ahb_manager_ahbif/HRESP
add wave -noupdate -expand -group {AHB Manager AHBIF} /Vortex_wrapper_no_Vortex_tb/ahb_manager_ahbif/HRDATA
add wave -noupdate -expand -group {AHB Manager AHBIF} -divider Outputs
add wave -noupdate -expand -group {AHB Manager AHBIF} /Vortex_wrapper_no_Vortex_tb/ahb_manager_ahbif/HSEL
add wave -noupdate -expand -group {AHB Manager AHBIF} /Vortex_wrapper_no_Vortex_tb/expected_ahb_manager_ahbif_HSEL
add wave -noupdate -expand -group {AHB Manager AHBIF} /Vortex_wrapper_no_Vortex_tb/ahb_manager_ahbif/HWRITE
add wave -noupdate -expand -group {AHB Manager AHBIF} /Vortex_wrapper_no_Vortex_tb/expected_ahb_manager_ahbif_HWRITE
add wave -noupdate -expand -group {AHB Manager AHBIF} /Vortex_wrapper_no_Vortex_tb/ahb_manager_ahbif/HTRANS
add wave -noupdate -expand -group {AHB Manager AHBIF} /Vortex_wrapper_no_Vortex_tb/expected_ahb_manager_ahbif_HTRANS
add wave -noupdate -expand -group {AHB Manager AHBIF} /Vortex_wrapper_no_Vortex_tb/ahb_manager_ahbif/HSIZE
add wave -noupdate -expand -group {AHB Manager AHBIF} /Vortex_wrapper_no_Vortex_tb/expected_ahb_manager_ahbif_HSIZE
add wave -noupdate -expand -group {AHB Manager AHBIF} /Vortex_wrapper_no_Vortex_tb/ahb_manager_ahbif/HADDR
add wave -noupdate -expand -group {AHB Manager AHBIF} /Vortex_wrapper_no_Vortex_tb/expected_ahb_manager_ahbif_HADDR
add wave -noupdate -expand -group {AHB Manager AHBIF} /Vortex_wrapper_no_Vortex_tb/ahb_manager_ahbif/HWDATA
add wave -noupdate -expand -group {AHB Manager AHBIF} /Vortex_wrapper_no_Vortex_tb/expected_ahb_manager_ahbif_HWDATA
add wave -noupdate -expand -group {AHB Manager AHBIF} /Vortex_wrapper_no_Vortex_tb/ahb_manager_ahbif/HWSTRB
add wave -noupdate -expand -group {AHB Manager AHBIF} /Vortex_wrapper_no_Vortex_tb/expected_ahb_manager_ahbif_HWSTRB
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/Vortex_mem_req_valid
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/Vortex_mem_req_rw
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/Vortex_mem_req_byteen
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/Vortex_mem_req_addr
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/Vortex_mem_req_data
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/Vortex_mem_req_tag
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/Vortex_mem_req_ready
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/Vortex_mem_rsp_valid
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/Vortex_mem_rsp_data
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/Vortex_mem_rsp_tag
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/Vortex_mem_rsp_ready
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/Vortex_busy
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/Vortex_reset
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/Vortex_PC_reset_val
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/mem_slave_mem_req_valid
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/mem_slave_mem_req_rw
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/mem_slave_mem_req_byteen
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/mem_slave_mem_req_addr
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/mem_slave_mem_req_data
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/mem_slave_mem_req_tag
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/mem_slave_mem_req_ready
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/mem_slave_mem_rsp_valid
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/mem_slave_mem_rsp_data
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/mem_slave_mem_rsp_tag
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/mem_slave_mem_rsp_ready
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/ahb_manager_mem_req_valid
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/ahb_manager_mem_req_rw
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/ahb_manager_mem_req_byteen
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/ahb_manager_mem_req_addr
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/ahb_manager_mem_req_data
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/ahb_manager_mem_req_tag
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/ahb_manager_mem_req_ready
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/ahb_manager_mem_rsp_valid
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/ahb_manager_mem_rsp_data
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/ahb_manager_mem_rsp_tag
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/ahb_manager_mem_rsp_ready
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/mem_rsp_valid_buffer
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/next_mem_rsp_valid_buffer
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/mem_rsp_data_buffer
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/next_mem_rsp_data_buffer
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/mem_rsp_tag_buffer
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/next_mem_rsp_tag_buffer
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/double_mem_rsp
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/ctrl_status_busy
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/next_ctrl_status_busy
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/ctrl_status_start_triggered
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/ctrl_status_PC_reset_val
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/next_ctrl_status_PC_reset_val
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/ctrl_status_reset_state
add wave -noupdate -expand -group {Vortex Wrapper Internal Signals} /Vortex_wrapper_no_Vortex_tb/DUT/next_ctrl_status_reset_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {91 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 322
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
WaveRestoreZoom {81 ns} {144 ns}
