
//`include "uart_v2.sv"
`timescale 1ns / 1ps

module string_transmitter_tb;

    // Declare testbench signals
    logic clock;
    logic reset;
    logic [7:0] wr_data;
    logic tx;
    logic tx_done;
    logic tx_start;
    logic button;
    logic done;

    // Instantiate the uart_system_transmitter module
    string_transmitter uut (
        .clock(clock),
        .reset(reset),
        .button(button),
        .tx(tx),
        .done(done)
    );

    // Clock generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // 100 MHz clock
    end

    // Test sequence
    initial begin
        $dumpfile("tb.vcd");
        $dumpvars;
        // Initialize signals
        reset = 1;
        button = 0;

        // Apply reset
        #20;
        reset = 0;
        button = 1;

        #20;
        button = 0;
        // Wait for transmission to complete
        wait(done);

        
        $finish;
    end

    

endmodule