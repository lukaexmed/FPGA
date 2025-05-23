module mcs_bridge 
#(
    parameter BRG_BASE = 32'hc000_0000  
)
(
    // uBLAZE MCS I/O bus
    input logic [31:0] io_address,
    input logic io_addr_strobe,
    input logic [31:0] io_write_data,
    input logic io_write_strobe,
    input logic [3:0] io_byte_enable,
    output logic [31:0] io_read_data,
    input logic io_read_strobe,
    output logic io_ready,
    // FPro bus 
    output logic fp_video_cs, // Change 1: Added the video control signals
    output logic fp_mmio_cs,
    output logic fp_wr,
    output logic fp_rd,
    output logic [20:0] fp_addr,
    output logic [31:0] fp_wr_data,
    input logic [31:0] fp_rd_data
);
    
    // internal signals
    logic mcs_bridge_enable;
    logic [29:0] word_address;

    // address decoding
    assign mcs_bridge_enable = (io_address[31:24] == BRG_BASE[31:24]);
    assign fp_mmio_cs = mcs_bridge_enable & (io_address[23] == 0);
    assign fp_video_cs = mcs_bridge_enable & (io_address[23] == 1); // Change 2: Added the video control signals
    assign fp_addr = io_address[22:2]; // the mmio system is word addressed
    // bit 1 and 0 are always 0

    // control line conversion
    assign fp_wr = io_write_strobe;
    assign fp_rd = io_read_strobe;
    assign io_ready = 1'b1; // always ready

    // data line conversion
    assign fp_wr_data = io_write_data;
    assign io_read_data = fp_rd_data;



endmodule