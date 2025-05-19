
module prescaler
    #(parameter PRESCALER_WIDTH = 8)
    (
        input logic clock,
        input logic reset,
        input logic [PRESCALER_WIDTH-1:0] limit,
        output logic clock_enable
    );


logic [PRESCALER_WIDTH-1:0] counter;
logic temp;

always_ff @ (posedge clock) begin //always_ff of sys verilog, pomeni da modeliramo del ki vsebuje Dflipflop
    if(reset) begin
        counter <= 0;
        temp <= 0; //ne blokirajoci assignmen za sekvencno logiko
    end else begin
        counter <= counter + 1;
            if (counter == limit -1 ) begin
                counter <= 0;
                temp <= 1;
            end else
                temp <= 0;
    end
end

always_comb begin
    clock_enable = temp;
end

endmodule


// PWM controller
module PWM_controller 

(
    input logic clock,
    input logic reset,
    input logic [1:0] SW,
    input logic clock_enable,
    output logic PWM
);
    
    localparam pwm50 = 1 << (4-1);
    localparam pwm25 = 1 << (4-2);
    localparam pwm12_5 = 1 << (4-3);
    logic [3:0] count;
    logic [3:0] cikel;

    always_ff @( posedge clock) begin 
        if (reset) begin
            count <= 0;
            PWM <= 0;
        end
        else begin 
            if (clock_enable) begin
                count <= count + 1;
                if (count < cikel)
                    PWM <= 1;
                else
                    PWM <= 0;
            end
        end
    end
    
    always_comb begin : kalkulirajCikel
        case (SW)
            2'b00: cikel = 0;
            2'b01: cikel = pwm12_5;
            2'b10: cikel = pwm25;
            2'b11: cikel = pwm50;
            default: cikel = 0;
        endcase
    end

endmodule


module rgb_controller (
    input logic clock,
    input logic reset,
    input logic [5:0] SW,
    output logic [2:0] RGB
);

// define parameters
localparam PRESCALER_WIDTH =  12;
localparam LIMIT = 3125;

// define the limit_value
logic [PRESCALER_WIDTH-1:0] limit_value;
assign limit_value = LIMIT;

//logic [1:0] rdeca;
//logic [1:0] zelena;
//logic [1:0] modra;
//always_comb begin
//    case(SW[1:0])
//    2'b00 : rdeca <= 
//    2'b01 :
//    2'b10 :
//    2'b11 :
//    default :

//end

logic temp;
// instantiate the prescaler 
// produces a 32 kHz clock
prescaler #(
    .PRESCALER_WIDTH(12)    
) pre(
    .clock(clock),
    .reset(reset),
    .limit(limit_value),
    .clock_enable(temp)
);
//logic [27:0] counter;
//logic [11:0] temp;

//always_ff @ (posedge clock) begin //always_ff of sys verilog, pomeni da modeliramo del ki vsebuje Dflipflop
//    if(reset) begin
//        counter <= 0;
//        temp <= 0; //ne blokirajoci assignmen za sekvencno logiko
//    end else begin
//        counter <= counter + 1;
//            if (counter == LIMIT -1 ) begin
//                counter <= 0;
//                temp <= temp + 1;
//            end
//        end
//end


// instantiate the PWM controller for the red LED

PWM_controller red (
    .clock(clock),
    .reset(reset),
    .SW(SW[1:0]),
    .clock_enable(temp),
    .PWM(RGB[0])
);

// instantiate the PWM controller for the green LED

PWM_controller green (
    .clock(clock),
    .reset(reset),
    .SW(SW[3:2]),
    .clock_enable(temp),
    .PWM(RGB[1])
);

// instantiate the PWM controller for the blue LED

PWM_controller blue (
    .clock(clock),
    .reset(reset),
    .SW(SW[5:4]),
    .clock_enable(temp),
    .PWM(RGB[2])
);
endmodule