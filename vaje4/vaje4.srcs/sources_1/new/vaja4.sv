//¸ Components for stopwatch
module timer_0001s // General Purpose counter        
    #(parameter PRESCALER_WIDTH = 14,
      parameter LIMIT = 10000)
    (
        input logic clock,
        input logic reset,
        input start,
        output logic time_tick
    );

    // implement the counter that counts from 0 t0 LIMIT-1
    // the counter width is PRESCALER_WIDTH
    // when the counter reaches LIMIT, time_tick should be high for one clock cycle
    logic [PRESCALER_WIDTH-1:0] counter;
    logic temp;
    
    
    always_ff @ (posedge clock or posedge reset) begin //always_ff of sys verilog, pomeni da modeliramo del ki vsebuje Dflipflop
    if(reset) begin
        counter <= 0;
        time_tick <= 0; //ne blokirajoci assignmen za sekvencno logiko
    end else if(start)begin 
        if (counter == LIMIT-1 ) begin
            counter <= 0;
            time_tick <= 1;
        end else begin
            counter <= counter + 1;
            time_tick <= 0;
        end
    end else begin
        counter <= 0;
        time_tick <= 0;
    end
end


//assign time_tick = temp;


// zakaj sem invertiral
//always_comb begin
//    time_tick = ~temp;
//end 

endmodule


// Components for stopwatch
module mod_counter 
#(
    parameter MOD_COUNTER = 10,
    parameter WIDTH = 4
)
(
    input logic clock,
    input logic reset,
    input logic increment,
    output logic [WIDTH-1:0] counter,
    output logic overflow
);
     //cilj na 0.0001 inkrementira, to pred
    // implement the counter that counts from 0 to MOD_COUNTER-1
    // the counter width is WIDTH
    // when increment is high, the counter should increment by 1
    // overflow_tick is equal to 1 when the counter reaches its final value and increment is high
    
    logic temp;
       
always_ff @ (posedge clock) begin //always_ff of sys verilog, pomeni da modeliramo del ki vsebuje Dflipflop
    if(reset) begin
        counter <= 0;
    end else if(increment) begin
            if (counter == MOD_COUNTER-1) begin
                counter <= 0;
                overflow <= 1;
            end else begin
                overflow <= 0;
                counter <= counter + 1;
            end
    end else begin
        overflow <= 0;
    end
end    

//always_comb begin :ovrflw

//    if(counter == MOD_COUNTER-1) begin
//        counter <= 0;
//        overflow <= 1;
//    end else 
//        overflow <= 0;
    
//end

endmodule

// Components for 7-segment display

module anode_assert (
    input logic clock, // 100 MHz
    input logic reset, 
    input logic clock_enable, // will be high every 0.002 seconds
    output logic [7:0] anode_select // 8-bit signal, look at  the image in section Nexys A7 and Seven segment display 
);

    // counter that counts from 0 to 7
    logic [2:0] count;
    // implemet the 3-bit counter which counts when clock_enable is high



always_ff @ (posedge clock_enable or posedge reset) begin

    if(reset) begin
        count <= 0;
    end else begin
        count <= count +1;
        if(count == 7)
            count <= 0;
    end

end
    
//    end

    // assert anode_select
    assign anode_select = ~(1 << count);
    
    
endmodule


    module value_to_digit(
        input logic [31:0] value,
        input logic [7:0] anode_select,
        output logic [3:0] digit
    );
        
        // if anode_select is 0xFE, then digit is equal to value[3:0]
        // if anode_select is 0xFD, then digit is equal to value[7:4]
        // if anode_select is 0xFB, then digit is equal to value[11:8]
        // if anode_select is 0xF7, then digit is equal to value[15:12]
        // if anode_select is 0xEF, then digit is equal to value[19:16]
        // if anode_select is 0xDF, then digit is equal to value[23:20]
        // if anode_select is 0xBF, then digit is equal to value[27:24]
        // if anode_select is 0x7F, then digit is equal to value[31:28]ž
        
        always_comb begin : v_to_d
            case (anode_select)
                8'hFE: digit = value[3:0];
                8'hFD: digit = value[7:4];
                8'hFB: digit = value[11:8];
                8'hF7: digit = value[15:12];
                8'hEF: digit = value[19:16];
                8'hDF: digit = value[23:20];
                8'hBF: digit = value[27:24];
                8'h7F: digit = value[31:28];
                default: digit = value[31:28];
            endcase
        end
        
        
    endmodule

// purely comb module 

module digit_to_segments (
    input logic [3:0] digit,
    output logic [6:0] segs
);
    // if digit is 0, then segs is 7'b1000000
    // if digit is 1, then segs is 7'b1111001
    // etc.
        always_comb begin : d_to_s
        case (digit)
            0: segs = 7'b1000000;
            1: segs = 7'b1111001;
            2: segs = 7'b0100100;
            3: segs = 7'b0110000;
            4: segs = 7'b0011001;
            5: segs = 7'b0010010;
            6: segs = 7'b0000010;
            7: segs = 7'b1111000;
            8: segs = 7'b0000000;
            9: segs = 7'b0010000;
            default: segs = 7'b1000000;
        endcase
    end
    

endmodule


module SevSegDisplay (
    input logic clock,
    input logic reset,
    input logic [3:0] digit1, // Least significant digit
    input logic [3:0] digit2, // Next digit
    input logic [3:0] digit3, // Next digit
    input logic [3:0] digit4,
    input logic [3:0] digit5,
    input logic [3:0] digit6,
    input logic [3:0] digit7,
    input logic [3:0] digit8, // Most significant digit
    output logic [7:0] anode_select,
    output logic [6:0] segs
);

    logic [31:0] digit;
    
    logic temp;
    
    logic [7:0] segments;
    
    logic [3:0] dg;


    assign digit = {digit8, digit7, digit6, digit5, digit4, digit3, digit2, digit1};
    
    value_to_digit v2d (
    .value(digit),
    .anode_select(anode_select),
    .digit(dg)
);

    digit_to_segments d2s (
    .digit(dg),
    .segs(segs)
);
    
    
    anode_assert anAssrt (
    .clock(clock),
    .reset(reset),
    .clock_enable(temp),
    .anode_select(anode_select)
);

//zacasno bom ta timer zvezal na input clock 7segmenta, ker itak ni vezan na sistem clock
//takda bom v top modulu stpwatch nareo se eno urico ki bo sotal 0.002
timer_0001s #(
    .PRESCALER_WIDTH(14),
    .LIMIT(10000)    
) urica(
    .clock(clock),
    .reset(reset),
    .start(1),
    .time_tick(temp)
);
endmodule


module stopwatch (
    input logic clock,
    input logic reset,
    input logic start,
    output logic[7:0] anode_assert,
    output logic[6:0] segs
);

logic time_tick;


timer_0001s #(
    .PRESCALER_WIDTH(14),
    .LIMIT(10000)    
) urica(    
    .clock(clock),
    .reset(reset),
    .start(start),
    .time_tick(time_tick)
);

logic D1_overflow;
logic [3:0] D1_count;

mod_counter #(
    .MOD_COUNTER(10),
    .WIDTH(4)    
) D1 (
    .clock(clock),
    .reset(reset),
    .increment(time_tick),
    .counter(D1_count),
    .overflow(D1_overflow)
);



logic D2_overflow;
logic [3:0] D2_count;
logic D5_overflow;
logic [3:0] D5_count;
logic D4_overflow;
logic [3:0] D4_count;
logic D6_overflow;
logic [3:0] D6_count;
logic D3_overflow;
logic [3:0] D3_count;
logic D7_overflow;
logic [3:0] D7_count;
logic D8_overflow;
logic [3:0] D8_count; 

mod_counter #(
    .MOD_COUNTER(10),
    .WIDTH(4)    
) D2 (
    .clock(clock),
    .reset(reset),
    .increment(D1_overflow),
    .counter(D2_count),
    .overflow(D2_overflow)
);



mod_counter #(
    .MOD_COUNTER(10),
    .WIDTH(4)    
) D5 (
    .clock(clock),
    .reset(reset),
    .increment(D4_overflow),
    .counter(D5_count),
    .overflow(D5_overflow)
);




mod_counter #(
    .MOD_COUNTER(6),
    .WIDTH(4)    
) D6 (
    .clock(clock),
    .reset(reset),
    .increment(D5_overflow),
    .counter(D6_count),
    .overflow(D6_overflow)
);




mod_counter #(
    .MOD_COUNTER(10),
    .WIDTH(4)    
) D3 (
    .clock(clock),
    .reset(reset),
    .increment(D2_overflow),
    .counter(D3_count),
    .overflow(D3_overflow)
);




mod_counter #(
    .MOD_COUNTER(10),
    .WIDTH(4)    
) D7 (
    .clock(clock),
    .reset(reset),
    .increment(D6_overflow),
    .counter(D7_count),
    .overflow(D7_overflow)
);




mod_counter #(
    .MOD_COUNTER(10),
    .WIDTH(4)    
) D4 (
    .clock(clock),
    .reset(reset),
    .increment(D3_overflow),
    .counter(D4_count),
    .overflow(D4_overflow)
);




mod_counter #(
    .MOD_COUNTER(6),
    .WIDTH(4)    
) D8 (
    .clock(clock),
    .reset(reset),
    .increment(D7_overflow),
    .counter(D8_count),
    .overflow(D8_overflow)
);

//=====================================
//7 segment
//logic tempUra;
//timer_0001s #(
//    .PRESCALER_WIDTH(14),
//    .LIMIT(200000)    
//) ura_seg (
//    .clock(clock),
//    .reset(reset),
//    .start(1),
//    .time_tick(tempUra)
//);

SevSegDisplay sevenSeg (
    .clock(clock),
    .reset(reset),
    .digit1(D1_count),
    .digit2(D2_count),
    .digit3(D3_count),
    .digit4(D4_count),
    .digit5(D5_count),
    .digit6(D6_count),
    .digit7(D7_count),
    .digit8(D8_count),
    .anode_select(anode_assert),
    .segs(segs)
    
);


endmodule



