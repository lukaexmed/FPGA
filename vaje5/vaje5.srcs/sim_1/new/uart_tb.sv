// `include "uart.sv"

module uart_tb;

    // Parameters
    parameter DATA_WIDTH = 16;

    // Signals
    logic clk;
    logic rst;
    logic [DATA_WIDTH-1:0] data_in;
    logic write_data;
    logic shr_en;
    logic data_out;

    // Instantiate the PISO_shifter module
    PISO_shifter #(
        .DATA_WIDTH(DATA_WIDTH)
    ) uut (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .write_data(write_data),
        .shr_en(shr_en),
        .data_out(data_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period
    end

    // Test sequence
    initial begin
        // Initialize signals
        $dumpfile("tb.vcd");
        $dumpvars;

        rst = 1;
        data_in = 0;
        write_data = 0;
        shr_en = 0;

        // Reset the design
        #10;
        rst = 0;

        // Write data to the shifter
        #10;
        data_in = 16'hA5A5;
        write_data = 1;
        #10;
        write_data = 0;

        // Shift right enable
        #10;
        shr_en = 1;
        #50; // Shift all bits out
        shr_en = 0;
        #20
        shr_en = 1;
        #70
        // Finish simulation
        #10;
        $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time: %0t | rst: %b | data_in: %h | write_data: %b | shr_en: %b | data_out: %b", 
                 $time, rst, data_in, write_data, shr_en, data_out);
    end

endmodule