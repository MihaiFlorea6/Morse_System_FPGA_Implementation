module seven_segment_driver (
    input  wire clk,
    input  wire reset,
    input  wire [6:0] char0, 
    input  wire [6:0] char1, 
    input  wire [6:0] char2,
    input  wire [6:0] char3, 
    output reg  [6:0] seg,
    output reg  [3:0] an 
);

   
    localparam REFRESH_RATE_DIVIDER = 100000;
    reg [16:0] refresh_counter;

   
    reg [1:0] digit_selector;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            refresh_counter <= 0;
            digit_selector <= 0;
        end else begin
            if (refresh_counter == REFRESH_RATE_DIVIDER - 1) begin
                refresh_counter <= 0;
                digit_selector <= digit_selector + 1;
            end else begin
                refresh_counter <= refresh_counter + 1;
            end
        end
    end

    always @(*) begin
        case (digit_selector)
            2'b00: begin
                seg = char0;
                an = 4'b1110; 
            end
            2'b01: begin
                seg = char1;
                an = 4'b1101; 
            end
            2'b10: begin
                seg = char2;
                an = 4'b1011;
            end
            2'b11: begin
                seg = char3;
                an = 4'b0111; 
            end
            default: begin
                seg = 7'b1111111; 
                an = 4'b1111;  
            end
        endcase
    end

endmodule