module press_duration(
    input clk,
    input rst,
    input btn,
    output reg is_dash,
    output reg done
);
    reg [23:0] counter;
    reg btn_prev;
    parameter DASH_THRESHOLD = 24'd10_000_000; // ajustabil (~200ms pentru clk 100MHz)

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            is_dash <= 0;
            done <= 0;
            btn_prev <= 0;
        end else begin
            if (btn && !btn_prev)
                counter <= 0;
            else if (btn)
                counter <= counter + 1;

            if (!btn && btn_prev) begin
                is_dash <= (counter > DASH_THRESHOLD);
                done <= 1;
            end else begin
                done <= 0;
            end
            btn_prev <= btn;
        end
    end
endmodule
