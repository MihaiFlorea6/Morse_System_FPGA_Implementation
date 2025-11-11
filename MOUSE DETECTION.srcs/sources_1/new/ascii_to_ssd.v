module ascii_to_ssd(
    input [7:0] ascii,
    output reg [6:0] seg
);
    always @(*) begin
        case (ascii)
            "S": seg = 7'b01101101;
            "O": seg = 7'b0111111;
            "T": seg = 7'b0001110;
            "E": seg = 7'b1001111;
            default: seg = 7'b0000001; // simbol ?
        endcase
    end
endmodule
