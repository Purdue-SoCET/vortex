onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Vortex_mem_slave_tb/PROG/clk
add wave -noupdate /Vortex_mem_slave_tb/PROG/reset
add wave -noupdate /Vortex_mem_slave_tb/PROG/test_num
add wave -noupdate /Vortex_mem_slave_tb/PROG/test_string
add wave -noupdate /Vortex_mem_slave_tb/PROG/task_string
add wave -noupdate -color Gold /Vortex_mem_slave_tb/PROG/testing
add wave -noupdate -color Red /Vortex_mem_slave_tb/PROG/error
add wave -noupdate /Vortex_mem_slave_tb/PROG/num_errors
add wave -noupdate -expand -group {AHB Generic Bus Interface Signals} -expand -group {Input Signals} /Vortex_mem_slave_tb/gbif/addr
add wave -noupdate -expand -group {AHB Generic Bus Interface Signals} -expand -group {Input Signals} /Vortex_mem_slave_tb/gbif/wdata
add wave -noupdate -expand -group {AHB Generic Bus Interface Signals} -expand -group {Input Signals} /Vortex_mem_slave_tb/gbif/ren
add wave -noupdate -expand -group {AHB Generic Bus Interface Signals} -expand -group {Input Signals} /Vortex_mem_slave_tb/gbif/wen
add wave -noupdate -expand -group {AHB Generic Bus Interface Signals} -expand -group {Input Signals} /Vortex_mem_slave_tb/gbif/byte_en
add wave -noupdate -expand -group {AHB Generic Bus Interface Signals} -expand -group {Output Signals} /Vortex_mem_slave_tb/PROG/expected_rdata
add wave -noupdate -expand -group {AHB Generic Bus Interface Signals} -expand -group {Output Signals} /Vortex_mem_slave_tb/gbif/rdata
add wave -noupdate -expand -group {AHB Generic Bus Interface Signals} -expand -group {Output Signals} /Vortex_mem_slave_tb/PROG/expected_busy
add wave -noupdate -expand -group {AHB Generic Bus Interface Signals} -expand -group {Output Signals} /Vortex_mem_slave_tb/gbif/busy
add wave -noupdate -expand -group {Vortex Memory Interface Signals} -expand -group {Input Signals} /Vortex_mem_slave_tb/PROG/mem_req_valid
add wave -noupdate -expand -group {Vortex Memory Interface Signals} -expand -group {Input Signals} /Vortex_mem_slave_tb/PROG/mem_req_rw
add wave -noupdate -expand -group {Vortex Memory Interface Signals} -expand -group {Input Signals} /Vortex_mem_slave_tb/PROG/mem_req_byteen
add wave -noupdate -expand -group {Vortex Memory Interface Signals} -expand -group {Input Signals} /Vortex_mem_slave_tb/PROG/mem_req_addr
add wave -noupdate -expand -group {Vortex Memory Interface Signals} -expand -group {Input Signals} /Vortex_mem_slave_tb/PROG/mem_req_data
add wave -noupdate -expand -group {Vortex Memory Interface Signals} -expand -group {Input Signals} /Vortex_mem_slave_tb/PROG/mem_req_ready
add wave -noupdate -expand -group {Vortex Memory Interface Signals} -expand -group {Input Signals} /Vortex_mem_slave_tb/PROG/mem_rsp_tag
add wave -noupdate -expand -group {Vortex Memory Interface Signals} -expand -group {Input Signals} /Vortex_mem_slave_tb/PROG/busy
add wave -noupdate -expand -group {Vortex Memory Interface Signals} -expand -group {Output Signals} /Vortex_mem_slave_tb/PROG/expected_mem_req_ready
add wave -noupdate -expand -group {Vortex Memory Interface Signals} -expand -group {Output Signals} /Vortex_mem_slave_tb/PROG/mem_rsp_ready
add wave -noupdate -expand -group {Vortex Memory Interface Signals} -expand -group {Output Signals} /Vortex_mem_slave_tb/PROG/expected_mem_rsp_valid
add wave -noupdate -expand -group {Vortex Memory Interface Signals} -expand -group {Output Signals} /Vortex_mem_slave_tb/PROG/mem_rsp_valid
add wave -noupdate -expand -group {Vortex Memory Interface Signals} -expand -group {Output Signals} /Vortex_mem_slave_tb/PROG/expected_mem_rsp_data
add wave -noupdate -expand -group {Vortex Memory Interface Signals} -expand -group {Output Signals} /Vortex_mem_slave_tb/PROG/mem_rsp_data
add wave -noupdate -expand -group {Vortex Memory Interface Signals} -expand -group {Output Signals} /Vortex_mem_slave_tb/PROG/expected_mem_rsp_tag
add wave -noupdate -expand -group {Vortex Memory Interface Signals} -expand -group {Output Signals} /Vortex_mem_slave_tb/PROG/mem_req_tag
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {110 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 242
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
WaveRestoreZoom {0 ns} {179 ns}
