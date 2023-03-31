onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group VX_ahb_adapter /VX_ahb_adapter_tb/DUT/clk
add wave -noupdate -expand -group VX_ahb_adapter /VX_ahb_adapter_tb/DUT/reset
add wave -noupdate -expand -group VX_ahb_adapter /VX_ahb_adapter_tb/DUT/count
add wave -noupdate -expand -group VX_ahb_adapter /VX_ahb_adapter_tb/DUT/state
add wave -noupdate -expand -group VX_ahb_adapter /VX_ahb_adapter_tb/DUT/nxt_state
add wave -noupdate -expand -group VX_ahb_adapter /VX_ahb_adapter_tb/DUT/data_read
add wave -noupdate -expand -group VX_ahb_adapter /VX_ahb_adapter_tb/DUT/nxt_data_read
add wave -noupdate -expand -group VX_ahb_adapter /VX_ahb_adapter_tb/DUT/full_addr
add wave -noupdate -expand -group VX_ahb_adapter /VX_ahb_adapter_tb/DUT/nxt_data
add wave -noupdate -expand -group VX_ahb_adapter /VX_ahb_adapter_tb/DUT/data
add wave -noupdate -expand -group VX_ahb_adapter /VX_ahb_adapter_tb/DUT/nxt_rw
add wave -noupdate -expand -group VX_ahb_adapter /VX_ahb_adapter_tb/DUT/rw
add wave -noupdate -expand -group VX_ahb_adapter /VX_ahb_adapter_tb/DUT/clear
add wave -noupdate -expand -group VX_ahb_adapter /VX_ahb_adapter_tb/DUT/count_en
add wave -noupdate -expand -group VX_ahb_adapter /VX_ahb_adapter_tb/DUT/nxt_addr
add wave -noupdate -expand -group VX_ahb_adapter /VX_ahb_adapter_tb/DUT/addr
add wave -noupdate -expand -group {AHB interface} /VX_ahb_adapter_tb/ahbif/HCLK
add wave -noupdate -expand -group {AHB interface} /VX_ahb_adapter_tb/ahbif/HRESETn
add wave -noupdate -expand -group {AHB interface} /VX_ahb_adapter_tb/ahbif/HSEL
add wave -noupdate -expand -group {AHB interface} /VX_ahb_adapter_tb/ahbif/HREADY
add wave -noupdate -expand -group {AHB interface} /VX_ahb_adapter_tb/ahbif/HREADYOUT
add wave -noupdate -expand -group {AHB interface} /VX_ahb_adapter_tb/ahbif/HWRITE
add wave -noupdate -expand -group {AHB interface} /VX_ahb_adapter_tb/ahbif/HMASTLOCK
add wave -noupdate -expand -group {AHB interface} /VX_ahb_adapter_tb/ahbif/HRESP
add wave -noupdate -expand -group {AHB interface} /VX_ahb_adapter_tb/ahbif/HTRANS
add wave -noupdate -expand -group {AHB interface} /VX_ahb_adapter_tb/ahbif/HBURST
add wave -noupdate -expand -group {AHB interface} /VX_ahb_adapter_tb/ahbif/HSIZE
add wave -noupdate -expand -group {AHB interface} /VX_ahb_adapter_tb/ahbif/HADDR
add wave -noupdate -expand -group {AHB interface} /VX_ahb_adapter_tb/ahbif/HWDATA
add wave -noupdate -expand -group {AHB interface} /VX_ahb_adapter_tb/ahbif/HRDATA
add wave -noupdate -expand -group {mem request} /VX_ahb_adapter_tb/mreqif/valid
add wave -noupdate -expand -group {mem request} /VX_ahb_adapter_tb/mreqif/rw
add wave -noupdate -expand -group {mem request} /VX_ahb_adapter_tb/mreqif/byteen
add wave -noupdate -expand -group {mem request} /VX_ahb_adapter_tb/mreqif/addr
add wave -noupdate -expand -group {mem request} /VX_ahb_adapter_tb/mreqif/data
add wave -noupdate -expand -group {mem request} /VX_ahb_adapter_tb/mreqif/ready
add wave -noupdate -expand -group {mem response} /VX_ahb_adapter_tb/mrspif/valid
add wave -noupdate -expand -group {mem response} /VX_ahb_adapter_tb/mrspif/data
add wave -noupdate -expand -group {mem response} /VX_ahb_adapter_tb/mrspif/ready
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {64 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 184
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
WaveRestoreZoom {0 ns} {250 ns}
