//Author: Raghul Prakash (socet33, prakasr)
//page table cache in Vortex
//takes vaddr in gives out paddr
`include "ahb_if.vh"
`include "VX_define.vh"

module page_table(
    input logic CLK,
    input logic nRST,
    output logic page_fault_reg,
    ahb_if.ahb_s ahb_s,

    output wire                             mem_req_pt_valid,
    input wire 				    mem_req_valid,
    
    output wire [`VX_MEM_ADDR_WIDTH-1:0]    mem_req_pt_addr,
    input wire [`VX_MEM_ADDR_WIDTH-1:0]     mem_req_addr
    );
    
    
    	wire [`VX_MEM_ADDR_WIDTH-1:0] vaddr;
    	assign vaddr = mem_req_addr;
    
	localparam WORD_W = 32;

	//htrans
	localparam IDLE = 'b00;
	localparam NON_SEQ = 'b10;
	localparam SEQ = 'b11;

	//hwrite needs to be high
	logic write_req, prev_write_req;
	logic [WORD_W-1:0] wreq_addr; //write request address

	localparam NVPN = 8;
	localparam log2NVP = 4 - 1;
	//8 virtual pages, 4 physical pages
	//ENTRY: PPN[3 bits] + VALID[1 bit] 
	logic [31:0][log2NVP:0] page_table_entry; 
	logic [31:0][log2NVP:0] n_page_table_entry;

	logic page_fault;
	logic n_page_fault;

	//logic for read
	logic [WORD_W-1:0] read_data;
	logic [WORD_W-1:0] next_read_data;

	logic [1:0] resp;
	logic [1:0] next_resp;
	logic ready;
	logic next_ready;
	logic read_req;


	//page table registers
	always_ff @ (posedge CLK, negedge nRST) begin
		if (nRST) begin
			page_table_entry[0] <= 32'b0;
			page_table_entry[1] <= 32'b0;
			page_table_entry[2] <= 32'b0;
			page_table_entry[3] <= 32'b0;
			page_table_entry[4] <= 32'b0;
			page_table_entry[5] <= 32'b0;
			page_table_entry[6] <= 32'b0;
			page_table_entry[7] <= 32'b0;
			page_fault <= 0;		
		end
		else begin
		       page_table_entry[0] <= n_page_table_entry[0];
                       page_table_entry[1] <= n_page_table_entry[1];
                       page_table_entry[2] <= n_page_table_entry[2];
                       page_table_entry[3] <= n_page_table_entry[3];
                       page_table_entry[4] <= n_page_table_entry[4];
                       page_table_entry[5] <= n_page_table_entry[5];
                       page_table_entry[6] <= n_page_table_entry[6];
		       page_table_entry[7] <= n_page_table_entry[7];
		       page_fault <= n_page_fault;
		end
	end	

	//control signals
	always_ff @ (posedge CLK, negedge nRST) begin
	    if (nRST == 1'b0) begin
		read_data <= 'h0;
		prev_write_req <= '0;
	    end
	    else begin
		if(read_req) begin
		    read_data <= next_read_data;
		end
		resp <= next_resp;
		ready <= next_ready;
		prev_write_req <= write_req;
	    end
	end

	assign wreq_addr = ahb_s.HADDR;
	assign write_req = ahb_s.HSEL & ahb_s.HWRITE & (ahb_s.HTRANS == NON_SEQ);
	assign read_req = ahb_s.HSEL & ~ahb_s.HWRITE & (ahb_s.HTRANS == NON_SEQ);
	
	//Just going to assume HSIZE will be 1 word for now -- will change. 
	always_comb begin 
	    n_page_table_entry[0] = page_table_entry[0];
	    n_page_table_entry[1] = page_table_entry[1];
	    n_page_table_entry[2] = page_table_entry[2];
	    n_page_table_entry[3] = page_table_entry[3];
	    n_page_table_entry[4] = page_table_entry[4];
	    n_page_table_entry[5] = page_table_entry[5];
	    n_page_table_entry[6] = page_table_entry[6];
	    n_page_table_entry[7] = page_table_entry[7];
	    //next_status_r = status_r;
	    next_resp = 'b01; //if no write == invalid addr
	    next_ready = 'b1;  //FIX REQUIRED
	    //status_read_flag = '0;

		if(write_req) begin
		    n_page_table_entry[wreq_add] = ahb_s.HWDATA;
		    next_resp = 'b00;
		    next_ready = 'b1;
		end
		
		if(read_req) begin
		    //wreq_addr == rreq_addr
		    next_read_data = page_table_entry[wreq_addr];
		    next_resp = 'b00; 
		    next_ready = 'b1;
		end


	    endcase

	end
	

	assign ahb_s.HRDATA = read_data; //can add "read_req? read_data: 'h0;" if needed 
	//assign ahb_s.HREADY = ready; //Was HREADYOUT previously idk why
	assign ahb_s.HREADYOUT = ready;
	assign ahb_s.HRESP = resp;


	//page table entry translation
	//calculate page number from virtual page
	//16 KB pages (vaddr == 32 bits, VPN == vaddr 
	//32 bits 0x0 addr vpn = 0
	//16kb = 2^4 x 2^10 = 14 bits
	logic valid;
	logic [31:0] VPN;
	logic [31:0] PPN;
	assign VPN = (vaddr >> 13); //get page number
	assign PPN = page_table_entry_reg[vaddr >> 13][log2NVP:0]; //get page number
	assign valid = page_table_entry_reg[vaddr >> 13][4]; //valid bit 
	
	always_comb begin
		paddr = 0;
		n_page_fault = 0;
		if (valid) begin
			paddr = ((PPN << 13) | vaddr[12:0]); //check if valid (calculate paddr)
		end
		else begin
			paddr = 32'hdeadbeef;
			n_page_fault = 1; //page fault
		end
	end
	
	assign mem_req_pt_valid = mem_req_valid & ~page_fault;	

end module
