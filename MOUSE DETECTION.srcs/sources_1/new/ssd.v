module seven_seg_display(
    input clk,
    input [7:0] ascii,
    output reg [6:0] seg,
    output reg [3:0] an
);
    always @(posedge clk) begin
        an <= 4'b1110; // doar prima cifră activă
        case (ascii)
            "E": seg <= 7'b0000110;
            "T": seg <= 7'b1110000;
            "S": seg <= 7'b0010010;
            "O": seg <= 7'b0000001;
            "?": seg <= 7'b0111111;
            default: seg <= 7'b1111111;
        endcase
    end
endmodule
