module debouncer(
    input clk,
    input btn,
    output reg out
);
    reg [19:0] count;
    reg btn_sync;

    always @(posedge clk) begin
        btn_sync <= btn;
        if (btn_sync == btn)
            count <= count + 1;
        else
            count <= 0;

        if (count == 20'hFFFFF)
            out <= btn;
    end
endmodule
