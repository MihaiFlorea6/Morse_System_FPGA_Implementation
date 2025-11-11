module morse_decoder(
    input clk,
    input rst,
    input new_symbol,
    input is_dash,
    input done,
    output reg [7:0] letter // ASCII
);
    reg [2:0] symbols;
    reg [1:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            symbols <= 0;
            count <= 0;
            letter <= " ";
        end else begin
            if (new_symbol) begin
                symbols <= {symbols[1:0], is_dash};
                count <= count + 1;
            end
            if (done) begin
                case ({count, symbols})
                    {2'd3, 3'b000}: letter <= "S";
                    {2'd3, 3'b111}: letter <= "O";
                    {2'd1, 3'b1}:   letter <= "T";
                    {2'd1, 3'b0}:   letter <= "E";
                    default:        letter <= "?";
                endcase
                symbols <= 0;
                count <= 0;
            end
        end
    end
endmodule
