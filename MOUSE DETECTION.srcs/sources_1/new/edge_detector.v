module edge_detector(
    input clk,
    input signal,
    output reg rising_edge
);
    reg prev_signal;

    always @(posedge clk) begin
        rising_edge <= (signal && !prev_signal);
        prev_signal <= signal;
    end
endmodule
