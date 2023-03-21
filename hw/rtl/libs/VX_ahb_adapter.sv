`include "VX_define.vh"

module VX_ahb_adapter #(
    parameter VX_DATA_WIDTH    = 512, 
    parameter VX_ADDR_WIDTH    = (32 - $clog2(VX_DATA_WIDTH/8)),            
    parameter VX_TAG_WIDTH     = 8,
    parameter AHB_DATA_WIDTH   = (VX_DATA_WIDTH / 16), 
    parameter AHB_ADDR_WIDTH   = 32,
    //parameter AHB_TID_WIDTH    = VX_TAG_WIDTH,
    parameter VX_BYTEEN_WIDTH  = (VX_DATA_WIDTH / 8),
    parameter AHB_STROBE_WIDTH = (AHB_DATA_WIDTH / 8)
) (
    input  wire                         clk,
    input  wire                         reset,

    // Vortex request
    input wire                          mem_req_valid,
    input wire                          mem_req_rw,
    input wire [VX_BYTEEN_WIDTH-1:0]    mem_req_byteen,
    input wire [VX_ADDR_WIDTH-1:0]      mem_req_addr,
    input wire [VX_DATA_WIDTH-1:0]      mem_req_data,
    input wire [VX_TAG_WIDTH-1:0]       mem_req_tag, //IGNORE, useful for AXI

    // Vortex response
    input wire                          mem_rsp_ready,
    output wire                         mem_rsp_valid,        
    output wire [VX_DATA_WIDTH-1:0]     mem_rsp_data,
    output wire [VX_TAG_WIDTH-1:0]      mem_rsp_tag, //IGNORE, useful for AXI
    output wire                         mem_req_ready,


    // AHB CHANNELS
    output wire HSEL,
    output wire [AHB_ADDR_WIDTH-1:0] HADDR,
    output wire [1:0] HTRANS,
    output wire [2:0] HSIZE,
    output wire HWRITE,
    output wire [AHB_DATA_WIDTH-1:0] HWDATA,
    input wire [AHB_DATA_WIDTH-1:0] HRDATA,
    input wire HREADY,
    input wire HRESP
    //to do: add burst
);

    localparam size = $clog2(VX_DATA_WIDTH/8);
    localparam num_cycles = (512/VX_DATA_WIDTH);

    typedef enum logic [1:0] {IDLE, DATA, COMPLETE, ERROR} states;

    states state, nxt_state;

    typedef struct packed {
        logic [31:0] data1;
        logic [31:0] data2;
        logic [31:0] data3;
        logic [31:0] data4;
        logic [31:0] data5;
        logic [31:0] data6;
        logic [31:0] data7;
        logic [31:0] data8;
        logic [31:0] data9;
        logic [31:0] data10;
        logic [31:0] data11;
        logic [31:0] data12;
        logic [31:0] data13;
        logic [31:0] data14;
        logic [31:0] data15;
        logic [31:0] data16;
    } data_buff;
    
    data_buff data_read, nxt_data_read; 

    logic [511:0] nxt_data, data;
    logic nxt_rw, rw;
    logic [25:0] nxt_addr, addr;
    
    always_ff @(posedge clk, negedge reset) begin : STATE_TRANSITIONS
        if (!reset)
            state <= IDLE;
            data <= '0;
            addr <= '0;
            rw <= '0;
            data_read <= '0;
        else
            data_read <= nxt_data_read;
            state <= nxt_state;
            data <= nxt_data;
            addr <= nxt_addr;
            rw <= nxt_rw;
    end

    always_comb begin : STATES_CTRL
        nxt_state = state;
        
        casez(state)

            IDLE: nxt_state = (mem_req_valid) ? DATA : IDLE;

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
        nxt_addr = addr;
        nxt_rw = rw;
        nxt_data = data;
        nxt_data_read = data_read;
        count_en = 0;
        clear = 0;
        mem_rsp_valid = 0;
        mem_req_ready = 0;

        case(state)
            IDLE: begin
                mem_req_ready = 1;
                if (mem_req_valid == 1) begin
                    HSEL = 1;
                    HSIZE = 3'b010;
                    HTRANS = 2'b10;
                    HWRITE = mem_req_rw;
                    HADDR = {mem_req_addr, 6'd0};
                    nxt_data = mem_req_data;
                    nxt_addr = mem_req_addr;
                    nxt_rw = mem_req_rw;
                    clear = 1;
                end
            end

            DATA: begin 
                if ((HREADY == 1)) begin
                    count_en = 1;
                    HSEL = 1;
                    HSIZE = 3'b010;
                    HTRANS = 2'b10;
                    HWRITE = rw;
                    HADDR = {addr + 4, 6'd0};
                    nxt_addr = addr + 4;
                    case (count)
                        4'd0: begin
                            nxt_data_read.data1 = HRDATA;
                            HWDATA = data[31:0];
                        end
                        4'd1: begin
                            nxt_data_read.data2 = HRDATA;
                            HWDATA = data[63:32];
                        end
                        4'd2: begin
                            nxt_data_read.data3 = HRDATA;
                            HWDATA = data[95:64];
                        end
                        4'd3: begin
                            nxt_data_read.data4 = HRDATA;
                            HWDATA = data[127:96];
                        end
                        4'd4: begin
                            nxt_data_read.data5 = HRDATA;
                            HWDATA = data[159:128];
                        end
                        4'd5: begin
                            nxt_data_read.data6 = HRDATA;
                            HWDATA = data[191:160];
                        end
                        4'd6: begin
                            nxt_data_read.data7 = HRDATA;
                            HWDATA = data[223:196];
                        end
                        4'd7: begin
                            nxt_data_read.data8 = HRDATA;
                            HWDATA = data[255:224];
                        end
                        4'd8: begin
                            nxt_data_read.data9 = HRDATA;
                            HWDATA = data[287:256];
                        end
                        4'd9: begin
                            nxt_data_read.data10 = HRDATA;
                            HWDATA = data[319:288];
                        end
                        4'd10: begin
                            nxt_data_read.data11 = HRDATA;
                            HWDATA = data[351:320];
                        end
                        4'd11: begin
                            nxt_data_read.data12 = HRDATA;
                            HWDATA = data[383:352];
                        end
                        4'd12: begin
                            nxt_data_read.data13 = HRDATA;
                            HWDATA = data[415:384];
                        end
                        4'd13: begin
                            nxt_data_read.data14 = HRDATA;
                            HWDATA = data[447:416];
                        end
                        4'd14: begin
                            nxt_data_read.data15 = HRDATA;
                            HWDATA = data[479:448];
                        end
                        4'd15: begin
                            nxt_data_read.data16 = HRDATA;
                            HWDATA = data[511:480];
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
                    HADDR = addr + 4;
                    case (count)
                        4'd0: HWDATA = data[31:0];
                        4'd1: HWDATA = data[63:32];
                        4'd2: HWDATA = data[95:64];
                        4'd3: HWDATA = data[127:96];
                        4'd4: HWDATA = data[159:128];
                        4'd5: HWDATA = data[191:160];
                        4'd6: HWDATA = data[223:196];
                        4'd7: HWDATA = data[255:224];
                        4'd8: HWDATA = data[287:256];
                        4'd9: HWDATA = data[319:288];
                        4'd10: HWDATA = data[351:320];
                        4'd11: HWDATA = data[383:352];
                        4'd12: HWDATA = data[415:384];
                        4'd13: HWDATA = data[447:416];
                        4'd14: HWDATA = data[479:448];
                        4'd15: HWDATA = data[511:480];
                    endcase
                end
            end

            COMPLETE: begin
                mem_rsp_valid = 1;
            end  
        endcase
    end

    assign mem_rsp_data = logic'(data_read);


endmodule
