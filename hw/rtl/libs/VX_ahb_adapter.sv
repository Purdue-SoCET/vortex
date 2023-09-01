`include "VX_define.vh"

module VX_ahb_adapter #(
    parameter VX_DATA_WIDTH    = 512, 
    parameter VX_ADDR_WIDTH    = (32 - $clog2(VX_DATA_WIDTH/8)),            
    parameter VX_TAG_WIDTH     = 8,
    parameter AHB_DATA_WIDTH   = (VX_DATA_WIDTH / 16), 
    parameter AHB_ADDR_WIDTH   = 32,
    //parameter AHB_TID_WIDTH    = VX_TAG_WIDTH,
    parameter VX_BYTEEN_WIDTH  = (VX_DATA_WIDTH / 8),
    parameter AHB_STROBE_WIDTH = 4
) (
    input  logic                         clk,
    input  logic                         reset,

    // Vortex request
    input logic                          mem_req_valid,
    input logic                          mem_req_rw,
    input logic [VX_BYTEEN_WIDTH-1:0]    mem_req_byteen,
    input logic [VX_ADDR_WIDTH-1:0]      mem_req_addr,
    input logic [VX_DATA_WIDTH-1:0]      mem_req_data,
    input logic [55:0]       mem_req_tag,

    // Vortex response
    input logic                          mem_rsp_ready,
    output logic                         mem_rsp_valid,        
    output logic [VX_DATA_WIDTH-1:0]     mem_rsp_data,
    output logic [55:0]      mem_rsp_tag,
    output logic                         mem_req_ready,

    //AHB signals
    input logic HREADY, HRESP,
    input logic [31:0] HRDATA,
    output logic HWRITE,
    output logic [1:0] HTRANS,
    output logic [2:0] HBURST,
    output logic [2:0] HSIZE,
    output logic [31:0] HADDR,
    output logic [31:0] HWDATA,
    output logic [3:0] HWSTRB,
    output logic HSEL

    // ahb_if.manager ahb,
    // VX_mem_req_if.slave req,
    // VX_mem_rsp_if.master rsp
    
    //to do: add burst
);

    logic [3:0] count;
    localparam size = $clog2(VX_DATA_WIDTH/8);
    localparam num_cycles = (512/VX_DATA_WIDTH);

    typedef enum logic [2:0] {IDLE, DATA, START, COMPLETE, ERROR} states;

    states state, nxt_state;
    
    logic [15:0] [31:0] data_read;
    logic [15:0] [31:0] nxt_data_read;


    logic [31:0] full_addr;

    logic [511:0] nxt_data, data;
    logic [55:0] nxt_tag, tag;
    logic nxt_rw, rw, clear, count_en;
    logic [31:0] nxt_addr, addr;
    logic [63:0] nxt_byteen, byteen;
    
    always_ff @(posedge clk) begin : STATE_TRANSITIONS
        if (!reset) begin
            state <= IDLE;
            data <= '0;
            addr <= '0;
            rw <= '0;
            data_read <= '0;
            tag <= '0;
            byteen <= '0;
        end
        else begin
            data_read <= nxt_data_read;
            state <= nxt_state;
            data <= nxt_data;
            addr <= nxt_addr;
            tag <= nxt_tag;
            rw <= nxt_rw;
            byteen <= nxt_byteen;
        end
    end

    assign full_addr = {mem_req_addr, 6'd0};

    always_comb begin : STATES_CTRL
        nxt_state = state;
        
        case(state)

            IDLE: nxt_state = (mem_req_valid) ? START : IDLE;

            START: nxt_state = DATA;

            DATA: begin
                if ((HREADY == 1) && (count == 4'd15)) begin
                    nxt_state = COMPLETE;
                end
                else if (HRESP == 1)
                    nxt_state = ERROR;
                else begin
                    nxt_state = DATA;
                end
            end

            ERROR: begin
                nxt_state = IDLE;
            end

            COMPLETE: begin
                if (mem_rsp_ready == 1)
                    nxt_state = IDLE;
                else
                    nxt_state = COMPLETE;
            end
        endcase
    end

    always_comb begin : OUTPUTS
        HSEL = 0;
        HSIZE = '0;
        HTRANS = '0;
        HWRITE = 0;
        HADDR = '0;
        HWDATA = '0;
        HWSTRB = '0;
        nxt_addr = addr;
        nxt_rw = rw;
        nxt_data = data;
        nxt_data_read = data_read;
        nxt_byteen = byteen;
        nxt_tag = tag;
        count_en = 0;
        clear = 0;
        mem_rsp_valid = 0;
        mem_req_ready = 0;
        mem_rsp_tag = '0;

        case(state)
            IDLE: begin
                mem_req_ready = 1;
                if (mem_req_valid == 1) begin
                    nxt_data = mem_req_data;
                    nxt_addr = full_addr;
                    nxt_rw = mem_req_rw;
                    nxt_tag = mem_req_tag;
                    nxt_byteen = mem_req_byteen;
                    clear = 1;
                end
            end

            START: begin
                HSEL = 1;
                HSIZE = 3'b010;
                HTRANS = 2'b10;
                HWRITE = rw;
                HADDR = addr;
                nxt_addr = addr + 4;
            end

            DATA: begin 
                if ((HREADY == 1)) begin
                    count_en = 1;
                    HSEL = 1;
                    HSIZE = 3'b010;
                    HTRANS = 2'b10;
                    HWRITE = rw;
                    HADDR = addr;
                    nxt_addr = addr + 4;
                    case (count)
                        4'd0: begin
                            nxt_data_read[0] = HRDATA;
                            HWDATA = data[31:0];
                            HWSTRB = byteen[3:0];
                        end
                        4'd1: begin
                            nxt_data_read[1] = HRDATA;
                            HWDATA = data[63:32];
                            HWSTRB = byteen[7:4];
                        end
                        4'd2: begin
                            nxt_data_read[2] = HRDATA;
                            HWDATA = data[95:64];
                            HWSTRB = byteen[11:8];
                        end
                        4'd3: begin
                            nxt_data_read[3] = HRDATA;
                            HWDATA = data[127:96];
                            HWSTRB = byteen[15:12];
                        end
                        4'd4: begin
                            nxt_data_read[4] = HRDATA;
                            HWDATA = data[159:128];
                            HWSTRB = byteen[19:16];
                        end
                        4'd5: begin
                            nxt_data_read[5] = HRDATA;
                            HWDATA = data[191:160];
                            HWSTRB = byteen[23:20];
                        end
                        4'd6: begin
                            nxt_data_read[6] = HRDATA;
                            HWDATA = data[223:192];
                            HWSTRB = byteen[27:24];
                        end
                        4'd7: begin
                            nxt_data_read[7] = HRDATA;
                            HWDATA = data[255:224];
                            HWSTRB = byteen[31:28];
                        end
                        4'd8: begin
                            nxt_data_read[8] = HRDATA;
                            HWDATA = data[287:256];
                            HWSTRB = byteen[35:32];
                        end
                        4'd9: begin
                            nxt_data_read[9] = HRDATA;
                            HWDATA = data[319:288];
                            HWSTRB = byteen[39:36];
                        end
                        4'd10: begin
                            nxt_data_read[10] = HRDATA;
                            HWDATA = data[351:320];
                            HWSTRB = byteen[43:40];
                        end
                        4'd11: begin
                            nxt_data_read[11] = HRDATA;
                            HWDATA = data[383:352];
                            HWSTRB = byteen[47:44];
                        end
                        4'd12: begin
                            nxt_data_read[12] = HRDATA;
                            HWDATA = data[415:384];
                            HWSTRB = byteen[51:48];
                        end
                        4'd13: begin
                            nxt_data_read[13] = HRDATA;
                            HWDATA = data[447:416];
                            HWSTRB = byteen[55:52];
                        end
                        4'd14: begin
                            nxt_data_read[14] = HRDATA;
                            HWDATA = data[479:448];
                            HWSTRB = byteen[59:56];
                        end
                        4'd15: begin
                            nxt_data_read[15] = HRDATA;
                            HWDATA = data[511:480];
                            HWSTRB = byteen[63:60];
                        end
                    endcase
                end
                else
                begin
                    count_en = 0;
                    HSEL = 1;
                    HSIZE = 3'b010;
                    HTRANS = 2'b10;
                    HWRITE = rw;
                    HADDR = addr;
                    case (count)
                        4'd0: begin
                            HWDATA = data[31:0];
                            HWSTRB = byteen[3:0];
                        end
                        4'd1: begin
                            HWDATA = data[63:32];
                            HWSTRB = byteen[7:4];
                        end
                        4'd2: begin
                            HWDATA = data[95:64];
                            HWSTRB = byteen[11:8];
                        end
                        4'd3: begin
                            HWDATA = data[127:96];
                            HWSTRB = byteen[15:12];
                        end
                        4'd4: begin
                            HWDATA = data[159:128];
                            HWSTRB = byteen[19:16];
                        end
                        4'd5: begin
                            HWDATA = data[191:160];
                            HWSTRB = byteen[23:20];
                        end
                        4'd6: begin
                            HWDATA = data[223:192];
                            HWSTRB = byteen[27:24];
                        end
                        4'd7: begin
                            HWDATA = data[255:224];
                            HWSTRB = byteen[31:28];
                        end
                        4'd8: begin
                            HWDATA = data[287:256];
                            HWSTRB = byteen[35:32];
                        end
                        4'd9: begin
                            HWDATA = data[319:288];
                            HWSTRB = byteen[39:36];
                        end
                        4'd10: begin
                            HWDATA = data[351:320];
                            HWSTRB = byteen[43:40];
                        end
                        4'd11: begin 
                            HWDATA = data[383:352];
                            HWSTRB = byteen[47:44];
                        end
                        4'd12: begin
                            HWDATA = data[415:384];
                            HWSTRB = byteen[51:48];
                        end
                        4'd13: begin
                            HWDATA = data[447:416];
                            HWSTRB = byteen[55:52];
                        end
                        4'd14: begin
                            HWDATA = data[479:448];
                            HWSTRB = byteen[59:56];
                        end
                        4'd15: begin
                            HWDATA = data[511:480];
                            HWSTRB = byteen[63:60];
                        end
                    endcase
                end
            end

            COMPLETE: begin
                mem_rsp_valid = 1;
                mem_rsp_tag = tag;
            end  
        endcase
    end

    assign mem_rsp_data = data_read;

    counter
    SIXTEEN(
        .clk(clk),
        .rst(reset),
        .clear(clear),
        .count_enable(count_en),
        .rollover_val(4'd15),
        .count_out(count)
    );

endmodule
