module morse_recognizer_top (
    input  wire clk,           
    input  wire reset,        
    input  wire morse_button, 
    output wire [6:0] seg,    
    output wire [3:0] an     
);

   
    wire btn_pressed_stable; 
    wire [6:0] char_to_display; 

    
    debouncer button_debouncer (
        .clk(clk),
        .reset(reset),
        .btn_in(morse_button),
        .btn_out(btn_pressed_stable)
    );

    
    morse_fsm morse_logic (
        .clk(clk),
        .reset(reset),
        .btn_pressed(btn_pressed_stable),
        .char_code(char_to_display)
    );

    
    seven_segment_driver display_driver (
        .clk(clk),
        .reset(reset),
        .char0(char_to_display), 
        .char1(7'b1111111),      
        .char2(7'b1111111),      
        .char3(7'b1111111),  
        .seg(seg),
        .an(an)
    );

endmodule