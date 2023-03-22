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

    // // Vortex request
    // input wire                          req.mem_req_valid,
    // input wire                          req.mem_req_rw,
    // input wire [VX_BYTEEN_WIDTH-1:0]    mem_req_byteen,
    // input wire [VX_ADDR_WIDTH-1:0]      req.mem_req_addr,
    // input wire [VX_DATA_WIDTH-1:0]      req.mem_req_data,
    // input wire [VX_TAG_WIDTH-1:0]       req.mem_req_tag, //IGNORE, useful for AXI

    // // Vortex response
    // input wire                          rsp.mem_rsp_ready,
    // output wire                         rsp.mem_rsp_valid,        
    // output wire [VX_DATA_WIDTH-1:0]     rsp.mem_rsp_data,
    // output wire [VX_TAG_WIDTH-1:0]      rsp.mem_rsp_tag, //IGNORE, useful for AXI
    // output wire                         req.mem_req_ready,


    ahb_if.manager ahb,
    VX_mem_req_if.slave req,
    VX_mem_rsp_if.master rsp
    
    
    //to do: add burst
);

    logic [3:0] count;
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

    logic [31:0] full_addr;

    logic [511:0] nxt_data, data;
    logic nxt_rw, rw, clear, count_en;
    logic [31:0] nxt_addr, addr;
    
    always_ff @(posedge clk, negedge reset) begin : STATE_TRANSITIONS
        if (!reset) begin
            state <= IDLE;
            data <= '0;
            addr <= '0;
            rw <= '0;
            data_read <= '0;
        end
        else begin
            data_read <= nxt_data_read;
            state <= nxt_state;
            data <= nxt_data;
            addr <= nxt_addr;
            rw <= nxt_rw;
        end
    end

    assign full_addr = {req.addr, 6'd0};

    always_comb begin : STATES_CTRL
        nxt_state = state;
        
        case(state)

            IDLE: nxt_state = (req.valid) ? DATA : IDLE;

            DATA: begin
                if ((ahb.HREADY == 1) && (count == 4'd15)) begin
                    nxt_state = COMPLETE;
                end
                else if (ahb.HRESP == 1)
                    nxt_state = ERROR;
                else begin
                    nxt_state = DATA;
                end
            end

            ERROR: begin
                nxt_state = IDLE;
            end

            COMPLETE: begin
                if (rsp.ready == 1)
                    nxt_state = IDLE;
                else
                    nxt_state = COMPLETE;
            end
        endcase
    end

    always_comb begin : OUTPUTS
        ahb.HSEL = 0;
        ahb.HSIZE = '0;
        ahb.HTRANS = '0;
        ahb.HWRITE = 0;
        ahb.HADDR = '0;
        ahb.HWDATA = '0;
        nxt_addr = addr;
        nxt_rw = rw;
        nxt_data = data;
        nxt_data_read = data_read;
        count_en = 0;
        clear = 0;
        rsp.valid = 0;
        req.ready = 0;

        case(state)
            IDLE: begin
                req.ready = 1;
                if (req.valid == 1) begin
                    ahb.HSEL = 1;
                    ahb.HSIZE = 3'b010;
                    ahb.HTRANS = 2'b10;
                    ahb.HWRITE = req.rw;
                    ahb.HADDR = full_addr;
                    nxt_data = req.data;
                    nxt_addr = full_addr;
                    nxt_rw = req.rw;
                    clear = 1;
                end
            end

            DATA: begin 
                if ((ahb.HREADY == 1)) begin
                    count_en = 1;
                    ahb.HSEL = 1;
                    ahb.HSIZE = 3'b010;
                    ahb.HTRANS = 2'b10;
                    ahb.HWRITE = rw;
                    ahb.HADDR = addr + 4;
                    nxt_addr = addr + 4;
                    case (count)
                        4'd0: begin
                            nxt_data_read.data1 = ahb.HRDATA;
                            ahb.HWDATA = data[31:0];
                        end
                        4'd1: begin
                            nxt_data_read.data2 = ahb.HRDATA;
                            ahb.HWDATA = data[63:32];
                        end
                        4'd2: begin
                            nxt_data_read.data3 = ahb.HRDATA;
                            ahb.HWDATA = data[95:64];
                        end
                        4'd3: begin
                            nxt_data_read.data4 = ahb.HRDATA;
                            ahb.HWDATA = data[127:96];
                        end
                        4'd4: begin
                            nxt_data_read.data5 = ahb.HRDATA;
                            ahb.HWDATA = data[159:128];
                        end
                        4'd5: begin
                            nxt_data_read.data6 = ahb.HRDATA;
                            ahb.HWDATA = data[191:160];
                        end
                        4'd6: begin
                            nxt_data_read.data7 = ahb.HRDATA;
                            ahb.HWDATA = data[223:196];
                        end
                        4'd7: begin
                            nxt_data_read.data8 = ahb.HRDATA;
                            ahb.HWDATA = data[255:224];
                        end
                        4'd8: begin
                            nxt_data_read.data9 = ahb.HRDATA;
                            ahb.HWDATA = data[287:256];
                        end
                        4'd9: begin
                            nxt_data_read.data10 = ahb.HRDATA;
                            ahb.HWDATA = data[319:288];
                        end
                        4'd10: begin
                            nxt_data_read.data11 = ahb.HRDATA;
                            ahb.HWDATA = data[351:320];
                        end
                        4'd11: begin
                            nxt_data_read.data12 = ahb.HRDATA;
                            ahb.HWDATA = data[383:352];
                        end
                        4'd12: begin
                            nxt_data_read.data13 = ahb.HRDATA;
                            ahb.HWDATA = data[415:384];
                        end
                        4'd13: begin
                            nxt_data_read.data14 = ahb.HRDATA;
                            ahb.HWDATA = data[447:416];
                        end
                        4'd14: begin
                            nxt_data_read.data15 = ahb.HRDATA;
                            ahb.HWDATA = data[479:448];
                        end
                        4'd15: begin
                            nxt_data_read.data16 = ahb.HRDATA;
                            ahb.HWDATA = data[511:480];
                        end
                    endcase
                end
                else
                begin
                    count_en = 0;
                    ahb.HSEL = 1;
                    ahb.HSIZE = 3'b010;
                    ahb.HTRANS = 2'b10;
                    ahb.HWRITE = rw;
                    ahb.HADDR = addr + 4;
                    case (count)
                        4'd0: ahb.HWDATA = data[31:0];
                        4'd1: ahb.HWDATA = data[63:32];
                        4'd2: ahb.HWDATA = data[95:64];
                        4'd3: ahb.HWDATA = data[127:96];
                        4'd4: ahb.HWDATA = data[159:128];
                        4'd5: ahb.HWDATA = data[191:160];
                        4'd6: ahb.HWDATA = data[223:196];
                        4'd7: ahb.HWDATA = data[255:224];
                        4'd8: ahb.HWDATA = data[287:256];
                        4'd9: ahb.HWDATA = data[319:288];
                        4'd10: ahb.HWDATA = data[351:320];
                        4'd11: ahb.HWDATA = data[383:352];
                        4'd12: ahb.HWDATA = data[415:384];
                        4'd13: ahb.HWDATA = data[447:416];
                        4'd14: ahb.HWDATA = data[479:448];
                        4'd15: ahb.HWDATA = data[511:480];
                    endcase
                end
            end

            COMPLETE: begin
                rsp.valid = 1;
            end  
        endcase
    end

    assign rsp.data = (data_read);

    counter
    SIXTEEN(
        .clk(clk),
        .n_rst(reset),
        .clear(clear),
        .count_enable(count_en),
        .rollover_val(4'd15),
        .count_out(count)
    );

endmodule
