onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /VX_local_mem_tb/clk
add wave -noupdate /VX_local_mem_tb/reset
add wave -noupdate -divider {Vortex Signals}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group I-fetch -expand -group {I-cache req if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/icache_req_if/valid}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group I-fetch -expand -group {I-cache req if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/icache_req_if/addr}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group I-fetch -expand -group {I-cache req if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/icache_req_if/tag}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group I-fetch -expand -group {I-cache req if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/icache_req_if/ready}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group I-fetch -expand -group {I-cache rsp if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/icache_rsp_if/valid}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group I-fetch -expand -group {I-cache rsp if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/icache_rsp_if/data}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group I-fetch -expand -group {I-cache rsp if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/icache_rsp_if/tag}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group I-fetch -expand -group {I-cache rsp if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/icache_rsp_if/ready}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group I-fetch -expand -group {I-fetch req if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/ifetch_req_if/valid}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group I-fetch -expand -group {I-fetch req if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/ifetch_req_if/uuid}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group I-fetch -expand -group {I-fetch req if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/ifetch_req_if/tmask}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group I-fetch -expand -group {I-fetch req if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/ifetch_req_if/wid}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group I-fetch -expand -group {I-fetch req if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/ifetch_req_if/PC}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group I-fetch -expand -group {I-fetch req if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/fetch/ifetch_req_if/ready}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group I-fetch -expand -group {I-fetch rsp if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/ifetch_rsp_if/valid}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group I-fetch -expand -group {I-fetch rsp if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/ifetch_rsp_if/uuid}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group I-fetch -expand -group {I-fetch rsp if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/ifetch_rsp_if/tmask}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group I-fetch -expand -group {I-fetch rsp if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/ifetch_rsp_if/wid}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group I-fetch -expand -group {I-fetch rsp if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/ifetch_rsp_if/PC}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group I-fetch -expand -group {I-fetch rsp if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/ifetch_rsp_if/data}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core -expand -group Pipeline -expand -group Fetch -expand -group I-fetch -expand -group {I-fetch rsp if} {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/pipeline/ifetch_rsp_if/ready}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/CORE_ID}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_req_valid}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_req_rw}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_req_byteen}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_req_addr}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_req_data}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_req_tag}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_req_ready}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_rsp_valid}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_rsp_data}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_rsp_tag}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/mem_rsp_ready}
add wave -noupdate -expand -group Vortex -expand -group Cluster -expand -group Core {/VX_local_mem_tb/DUT/genblk1[0]/cluster/genblk1[0]/core/busy}
add wave -noupdate -expand -group Vortex -expand -group Cluster {/VX_local_mem_tb/DUT/genblk1[0]/cluster/CLUSTER_ID}
add wave -noupdate -expand -group Vortex -expand -group Cluster {/VX_local_mem_tb/DUT/genblk1[0]/cluster/mem_req_valid}
add wave -noupdate -expand -group Vortex -expand -group Cluster {/VX_local_mem_tb/DUT/genblk1[0]/cluster/mem_req_rw}
add wave -noupdate -expand -group Vortex -expand -group Cluster {/VX_local_mem_tb/DUT/genblk1[0]/cluster/mem_req_byteen}
add wave -noupdate -expand -group Vortex -expand -group Cluster {/VX_local_mem_tb/DUT/genblk1[0]/cluster/mem_req_addr}
add wave -noupdate -expand -group Vortex -expand -group Cluster {/VX_local_mem_tb/DUT/genblk1[0]/cluster/mem_req_data}
add wave -noupdate -expand -group Vortex -expand -group Cluster {/VX_local_mem_tb/DUT/genblk1[0]/cluster/mem_req_tag}
add wave -noupdate -expand -group Vortex -expand -group Cluster {/VX_local_mem_tb/DUT/genblk1[0]/cluster/mem_req_ready}
add wave -noupdate -expand -group Vortex -expand -group Cluster {/VX_local_mem_tb/DUT/genblk1[0]/cluster/mem_rsp_valid}
add wave -noupdate -expand -group Vortex -expand -group Cluster {/VX_local_mem_tb/DUT/genblk1[0]/cluster/mem_rsp_data}
add wave -noupdate -expand -group Vortex -expand -group Cluster {/VX_local_mem_tb/DUT/genblk1[0]/cluster/mem_rsp_tag}
add wave -noupdate -expand -group Vortex -expand -group Cluster {/VX_local_mem_tb/DUT/genblk1[0]/cluster/mem_rsp_ready}
add wave -noupdate -expand -group Vortex -expand -group Cluster {/VX_local_mem_tb/DUT/genblk1[0]/cluster/busy}
add wave -noupdate -expand -group Vortex -expand -group Cluster {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_mem_req_valid}
add wave -noupdate -expand -group Vortex -expand -group Cluster {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_mem_req_rw}
add wave -noupdate -expand -group Vortex -expand -group Cluster {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_mem_req_byteen}
add wave -noupdate -expand -group Vortex -expand -group Cluster {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_mem_req_addr}
add wave -noupdate -expand -group Vortex -expand -group Cluster {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_mem_req_data}
add wave -noupdate -expand -group Vortex -expand -group Cluster {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_mem_req_tag}
add wave -noupdate -expand -group Vortex -expand -group Cluster {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_mem_req_ready}
add wave -noupdate -expand -group Vortex -expand -group Cluster {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_mem_rsp_valid}
add wave -noupdate -expand -group Vortex -expand -group Cluster {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_mem_rsp_data}
add wave -noupdate -expand -group Vortex -expand -group Cluster {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_mem_rsp_tag}
add wave -noupdate -expand -group Vortex -expand -group Cluster {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_mem_rsp_ready}
add wave -noupdate -expand -group Vortex -expand -group Cluster {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_busy}
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
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/per_cluster_mem_req_valid
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/per_cluster_mem_req_rw
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/per_cluster_mem_req_byteen
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/per_cluster_mem_req_addr
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/per_cluster_mem_req_data
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/per_cluster_mem_req_tag
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/per_cluster_mem_req_ready
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/per_cluster_mem_rsp_valid
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/per_cluster_mem_rsp_data
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/per_cluster_mem_rsp_tag
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/per_cluster_mem_rsp_ready
add wave -noupdate -expand -group Vortex /VX_local_mem_tb/DUT/per_cluster_busy
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
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/wen_2_80002000
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/wsel_2_80002000
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/wdata_2_80002000
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/rsel_2_80002000
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/rdata_2_80002000
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/reg_val_2_80002000
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/next_reg_val_2_80002000
add wave -noupdate -expand -group {local_mem Signals} /VX_local_mem_tb/MEM/chunk_sel
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {343 ns} 0}
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
WaveRestoreZoom {0 ns} {3150 ns}
