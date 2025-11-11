module debouncer #(
    parameter CLK_FREQ = 100_000_000,
    parameter DEBOUNCE_TIME_MS = 20  
)(
    input  wire clk,
    input  wire reset,
    input  wire btn_in,
    output reg  btn_out
);

    localparam DEBOUNCE_CYCLES = (CLK_FREQ / 1000) * DEBOUNCE_TIME_MS;

    reg  [20:0] counter;
    reg  btn_intermediate;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            btn_intermediate <= 0;
            btn_out <= 0;
        end else begin
            if (btn_in != btn_intermediate) begin
                
                counter <= 0;
                btn_intermediate <= btn_in;
            end else if (counter < DEBOUNCE_CYCLES) begin
                
                counter <= counter + 1;
            end else begin
                
                btn_out <= btn_intermediate;
            end
        end
    end

endmodule