
module prescaler
    #(parameter PRESCALER_WIDTH = 8)
    (
        input logic clock,
        input logic reset,
        input logic [PRESCALER_WIDTH-1:0] limit,
        output logic clock_enable
    );


logic [PRESCALER_WIDTH-1:0] counter;
logic [11:0] temp;

always_ff @ (posedge clock) begin //always_ff of sys verilog, pomeni da modeliramo del ki vsebuje Dflipflop
    if(reset) begin
        counter <= 0;
        temp <= 0; //ne blokirajoci assignmen za sekvencno logiko
    end else begin
        counter <= counter + 1;
            if (counter == limit -1 ) begin
                counter <= 0;
                temp <= temp + 1;
            end
        end
end

always_comb begin
    clock_enable <= temp;
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

    // define the parameters
    localparam 50 = 1 << (4-1);
    localparam 25 = 1 << (4-2);
    localparam DT_12_5 = 1 << (4-3);

    // resolution of the PWM
    logic [4-1:0] count;
    logic [4-1:0] duty_cycle;

    always_ff @( posedge clock) begin 
        if (reset) begin
            count <= 0;
            PWM <= 0;
        end
        else begin 
            if (clock_enable) begin
                count <= count + 1;
                if (count < duty_cycle) begin
                    PWM <= 1;
                end
                else begin
                    PWM <= 0;
                end
            end
        end
    end
    
    always_comb begin : DutyCycleCalculate
        case (SW)
            2'b00: duty_cycle = 0;
            2'b01: duty_cycle = DT_12_5;
            2'b10: duty_cycle = DT_25;
            2'b11: duty_cycle = DT_50;
            default: duty_cycle = 0;
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
)pre(
    .clock(clock),
    .reset(reset),
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

PWM_controller #(
    .PRESCALER_WIDTH(12)    
)red (
    .clock(clock),
    .reset(reset),
    .SW(SW[1:0]),
    .clock_enable(temp),
    .PWM(RGB[0])
);

// instantiate the PWM controller for the green LED

PWM_controller #(
    .PRESCALER_WIDTH(12)    
)green (
    .clock(clock),
    .reset(reset),
    .SW(SW[3:2]),
    .clock_enable(temp),
    .PWM(RGB[1])
);

// instantiate the PWM controller for the blue LED

PWM_controller #(
    .PRESCALER_WIDTH(12)    
)blue (
    .clock(clock),
    .reset(reset),
    .SW(SW[5:4]),
    .clock_enable(temp),
    .PWM(RGB[2])
);
endmodule