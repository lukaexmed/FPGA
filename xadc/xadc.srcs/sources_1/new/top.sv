`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2024 09:09:33 AM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input clock,
    input reset,
    input [15:0] sw,
    input [3:0] adc_p,
    input [3:0] adc_n,
    output [15:0] led,
    output [7:0] anode_assert,
    output [6:0] segs
    );
    
    
 // instatiate MCS
 logic IO_addr_strobe;
 logic [31 : 0] IO_address;
 logic [3 : 0] IO_byte_enable;
 logic [31 : 0] IO_read_data;
 logic IO_read_strobe;
 logic IO_ready;
 logic [31 : 0] IO_write_data;
 logic IO_write_strobe;
    
  
microblaze_mcs_0 blazecore (
  .Clk(clock),                          // input wire Clk
  .Reset(reset),                      // input wire Reset
  .IO_addr_strobe(IO_addr_strobe),    // output wire IO_addr_strobe
  .IO_address(IO_address),            // output wire [31 : 0] IO_address
  .IO_byte_enable(IO_byte_enable),    // output wire [3 : 0] IO_byte_enable
  .IO_read_data(IO_read_data),        // input wire [31 : 0] IO_read_data
  .IO_read_strobe(IO_read_strobe),    // output wire IO_read_strobe
  .IO_ready(IO_ready),                // input wire IO_ready
  .IO_write_data(IO_write_data),      // output wire [31 : 0] IO_write_data
  .IO_write_strobe(IO_write_strobe)  // output wire IO_write_strobe
);
 
 
 
   
  
  // instantiate bridge 
  logic fp_video_cs;
  logic fp_mmio_cs;
  logic fp_wr;
  logic fp_rd;
  logic [20:0] fp_addr;
  logic [31:0] fp_wr_data;
  logic [31:0] fp_rd_data;
  
  localparam  BRG_BASE = 32'hc000_0000;
  

  
  mcs_bridge #(
    .BRG_BASE(BRG_BASE)
  )Bridge_inst(
    .io_address(IO_address),
    .io_addr_strobe(IO_addr_strobe),
    .io_write_data(IO_write_data),
    .io_write_strobe(IO_write_strobe),
    .io_byte_enable(IO_byte_enable),
    .io_read_data(IO_read_data),
    .io_read_strobe(IO_read_strobe),
    .io_ready(IO_ready),
    // FPro bus 
    .fp_video_cs(fp_video_cs),
    .fp_mmio_cs(fp_mmio_cs),
    .fp_wr(fp_wr),
    .fp_rd(fp_rd),
    .fp_addr(fp_addr),
    .fp_wr_data(fp_wr_data),
    .fp_rd_data(fp_rd_data)
  );
  
  //  mmio subsystem
  mmio_subsystem  mmio_inst(
      // clock and reset
      .clock(clock),
      .reset(reset),
      // from fpro brigge
      .mmio_cs(fp_mmio_cs),
      .mmio_address(fp_addr),
      .mmio_write_data(fp_wr_data),
      .mmio_write(fp_wr),
      .mmio_read_data(fp_rd_data),
      .mmio_read(fp_rd),
      // leds and switches to connect to board 
      .data_in(sw),
      .data_out(led),
      .anode_assert(anode_assert),
      .segs(segs),
      .adc_p(adc_p),
      .adc_n(adc_n)
  );
  
  
   
  
endmodule
