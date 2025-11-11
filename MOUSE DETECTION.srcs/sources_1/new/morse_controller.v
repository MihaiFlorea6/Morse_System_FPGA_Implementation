module morse_controller(
    input clk,
    input rst,
    input btn,
    output [7:0] letter,
    output [6:0] seg
);
    wire btn_db, btn_edge;
    wire is_dash, done;

    debouncer db(.clk(clk), .btn(btn), .out(btn_db));
    edge_detector ed(.clk(clk), .signal(btn_db), .rising_edge(btn_edge));
    press_duration pd(.clk(clk), .rst(rst), .btn(btn_db), .is_dash(is_dash), .done(done));

    morse_decoder md(
        .clk(clk),
        .rst(rst),
        .new_symbol(btn_edge),
        .is_dash(is_dash),
        .done(done),
        .letter(letter)
    );

    ascii_to_ssd ssd(.ascii(letter), .seg(seg));
endmodule
