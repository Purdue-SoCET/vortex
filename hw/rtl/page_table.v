//Author: Raghul Prakash
//page table cache in Vortex
//takes vaddr in gives out paddr
`include "ahb_if.vh"

module page_table_table(
    input logic [31:0] vaddr, 
    output logic [31:0] paddr, 
    input logic CLK,
    input logic nRST,
    input logic error,
    input logic finished,
    ahb_if.ahb_s ahb_s,
    output logic [31:0][3:0] page_table_entry_reg
    );
    

	localparam WORD_W = 32;

	//htrans
	localparam IDLE = 'b00;
	localparam NON_SEQ = 'b10;
	localparam SEQ = 'b11;

	//hwrite needs to be high
	logic write_req, prev_write_req;
	logic [WORD_W-1:0] wreq_addr; //write request address


	//4 virtual pages, 8 physical pages
	//ENTRY: PPN[3 bits] + VALID[1 bit] 
	logic [31:0][3:0] page_table_entry; 
	logic [31:0][3:0] n_page_table_entry;

	//logic for read
	logic [WORD_W-1:0] read_data;
	logic [WORD_W-1:0] next_read_data;

	logic [1:0] resp;
	logic [1:0] next_resp;
	logic ready;
	logic next_ready;
	logic read_req;


	always_ff @ (posedge CLK, negedge nRST) begin
		if (nRST) begin
			page_table_entry[0] <= 0;
			page_table_entry[1] <= 0;
			page_table_entry[2] <= 0;
			page_table_entry[3] <= 0;`
			page_table_entry[4] <= 0;
			page_table_entry[5] <= 0;
			page_table_entry[6] <= 0;
			page_table_entry[7] <= 0;		
		end
		else begin
			page_table_entry[0] <= npage_table_entry[0];
                       page_table_entry[1] <= npage_table_entry[1];
                       page_table_entry[2] <= npage_table_entry[2];
                       page_table_entry[3] <= npage_table_entry[3];
                       page_table_entry[4] <= npage_table_entry[4];
                       page_table_entry[5] <= npage_table_entry[5];
                       page_table_entry[6] <= npage_table_entry[6];
			page_table_entry[7] <= npage_table_entry[7];
		end
	end	


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
	
	//assign to output
	assign page_table_entry_reg[0] = page_table_entry[0];
	assign page_table_entry_reg[1] = page_table_entry[1];
	assign page_table_entry_reg[2] = page_table_entry[2];
	assign page_table_entry_reg[3] = page_table_entry[3];
	assign page_table_entry_reg[4] = page_table_entry[4];
	assign page_table_entry_reg[5] = page_table_entry[5];
	assign page_table_entry_reg[6] = page_table_entry[6];
	assign page_table_entry_reg[7] = page_table_entry[7];

	assign ahb_s.HRDATA = read_data; //can add "read_req? read_data: 'h0;" if needed 
	//assign ahb_s.HREADY = ready; //Was HREADYOUT previously idk why
	assign ahb_s.HREADYOUT = ready;
	assign ahb_s.HRESP = resp;


	//page table entry translation
	//calculate page number from virtual page
	assign paddr = page_table_entry_reg[vaddr >> 4];
	

end module
