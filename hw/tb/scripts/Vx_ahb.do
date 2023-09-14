onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group AHBif /VX_ahb_tb/ahbif/HCLK
add wave -noupdate -expand -group AHBif /VX_ahb_tb/ahbif/HRESETn
add wave -noupdate -expand -group AHBif /VX_ahb_tb/ahbif/HSEL
add wave -noupdate -expand -group AHBif /VX_ahb_tb/ahbif/HREADY
add wave -noupdate -expand -group AHBif /VX_ahb_tb/ahbif/HREADYOUT
add wave -noupdate -expand -group AHBif /VX_ahb_tb/ahbif/HWRITE
add wave -noupdate -expand -group AHBif /VX_ahb_tb/ahbif/HMASTLOCK
add wave -noupdate -expand -group AHBif /VX_ahb_tb/ahbif/HRESP
add wave -noupdate -expand -group AHBif /VX_ahb_tb/ahbif/HTRANS
add wave -noupdate -expand -group AHBif /VX_ahb_tb/ahbif/HBURST
add wave -noupdate -expand -group AHBif /VX_ahb_tb/ahbif/HSIZE
add wave -noupdate -expand -group AHBif /VX_ahb_tb/ahbif/HADDR
add wave -noupdate -expand -group AHBif /VX_ahb_tb/ahbif/HWDATA
add wave -noupdate -expand -group AHBif /VX_ahb_tb/ahbif/HRDATA
add wave -noupdate -expand -group AHBif /VX_ahb_tb/ahbif/HWSTRB
add wave -noupdate -expand -group bus_protocol_if /VX_ahb_tb/DUT/VX_bus_protocol_if/wen
add wave -noupdate -expand -group bus_protocol_if /VX_ahb_tb/DUT/VX_bus_protocol_if/ren
add wave -noupdate -expand -group bus_protocol_if /VX_ahb_tb/DUT/VX_bus_protocol_if/request_stall
add wave -noupdate -expand -group bus_protocol_if /VX_ahb_tb/DUT/VX_bus_protocol_if/addr
add wave -noupdate -expand -group bus_protocol_if /VX_ahb_tb/DUT/VX_bus_protocol_if/error
add wave -noupdate -expand -group bus_protocol_if /VX_ahb_tb/DUT/VX_bus_protocol_if/strobe
add wave -noupdate -expand -group bus_protocol_if /VX_ahb_tb/DUT/VX_bus_protocol_if/wdata
add wave -noupdate -expand -group bus_protocol_if /VX_ahb_tb/DUT/VX_bus_protocol_if/rdata
add wave -noupdate -expand -group bus_protocol_if /VX_ahb_tb/DUT/VX_bus_protocol_if/is_burst
add wave -noupdate -expand -group bus_protocol_if /VX_ahb_tb/DUT/VX_bus_protocol_if/burst_type
add wave -noupdate -expand -group bus_protocol_if /VX_ahb_tb/DUT/VX_bus_protocol_if/burst_length
add wave -noupdate -expand -group bus_protocol_if /VX_ahb_tb/DUT/VX_bus_protocol_if/secure_transfer
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {35 ns} 0}
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
WaveRestoreZoom {0 ns} {215 ns}
