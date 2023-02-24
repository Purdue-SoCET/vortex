onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /VX_local_mem_tb/clk
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
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/CLUSTER_ID}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/mem_req_valid}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/mem_req_rw}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/mem_req_byteen}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/mem_req_addr}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/mem_req_data}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/mem_req_tag}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/mem_req_ready}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/mem_rsp_valid}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/mem_rsp_data}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/mem_rsp_tag}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/mem_rsp_ready}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/busy}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_mem_req_valid}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_mem_req_rw}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_mem_req_byteen}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_mem_req_addr}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_mem_req_data}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_mem_req_tag}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_mem_req_ready}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_mem_rsp_valid}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_mem_rsp_data}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_mem_rsp_tag}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_mem_rsp_ready}
add wave -noupdate -expand -group Vortex {/VX_local_mem_tb/DUT/genblk1[0]/cluster/per_core_busy}
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/clk
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/reset
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/req_valid_in
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/req_tag_in
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/req_addr_in
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/req_rw_in
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/req_byteen_in
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/req_data_in
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/req_ready_in
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/req_valid_out
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/req_tag_out
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/req_addr_out
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/req_rw_out
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/req_byteen_out
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/req_data_out
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/req_ready_out
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/rsp_valid_in
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/rsp_tag_in
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/rsp_data_in
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/rsp_ready_in
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/rsp_valid_out
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/rsp_tag_out
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/rsp_data_out
add wave -noupdate -expand -group Vortex -group {Mem Arb1} /VX_local_mem_tb/DUT/genblk2/mem_arb/rsp_ready_out
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
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {298 ns} 0}
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
WaveRestoreZoom {2464 ns} {3316 ns}
