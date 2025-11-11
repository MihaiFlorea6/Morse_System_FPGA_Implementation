module morse_fsm (
    input  wire clk,
    input  wire reset,
    input  wire btn_pressed, 
    output reg  [6:0] char_code 
);
    
    localparam TIME_UNIT_MS = 100;
    localparam CLK_FREQ = 100_000_000;
    localparam TIME_UNIT_CYCLES = (CLK_FREQ / 1000) * TIME_UNIT_MS;

   
    localparam DOT_LIMIT = TIME_UNIT_CYCLES * 2; 
    localparam DASH_LIMIT = TIME_UNIT_CYCLES * 5; 

    localparam SYMBOL_GAP_LIMIT = TIME_UNIT_CYCLES * 2; 
    localparam LETTER_GAP_LIMIT = TIME_UNIT_CYCLES * 5;
    localparam WORD_GAP_LIMIT = TIME_UNIT_CYCLES * 10;

    
    localparam S_IDLE = 3'b001;          
    localparam S_PRESSED = 3'b010;       
    localparam S_RELEASED = 3'b100;      

    reg [2:0] state = S_IDLE;
    reg [2:0] next_state;

    
    reg [31:0] timer;

    
    reg [4:0] morse_sequence; 
    reg [2:0] sequence_len;

    
    function [6:0] decode_morse;
        input [2:0] len;
        input [4:0] seq;
        begin
            case ({len, seq})
               
                {3'd2, 5'b00001}: decode_morse = 7'b0001000; // A (.-)
                {3'd4, 5'b01000}: decode_morse = 7'b1000011; // B (-...)
                {3'd4, 5'b01010}: decode_morse = 7'b1000110; // C (-.-.)
                {3'd3, 5'b00100}: decode_morse = 7'b0100011; // D (-..)
                {3'd1, 5'b00000}: decode_morse = 7'b0000110; // E (.)
                {3'd4, 5'b00101}: decode_morse = 7'b0001110; // F (..-.)
                {3'd3, 5'b00110}: decode_morse = 7'b1001000; // G (--.)
                {3'd4, 5'b00000}: decode_morse = 7'b0011000; // H (....)
                {3'd2, 5'b00000}: decode_morse = 7'b1111001; // I (..)
                {3'd4, 5'b01110}: decode_morse = 7'b1110011; // J (.---)
                {3'd3, 5'b00101}: decode_morse = 7'b0010010; // K (-.-)
                {3'd4, 5'b01001}: decode_morse = 7'b1000111; // L (.-..)
                {3'd2, 5'b00011}: decode_morse = 7'b0010101; // M (--)
                {3'd2, 5'b00010}: decode_morse = 7'b1010011; // N (-.)
                {3'd3, 5'b00111}: decode_morse = 7'b1000011; // O (---)
                {3'd4, 5'b01101}: decode_morse = 7'b0001100; // P (.--.)
                {3'd4, 5'b01011}: decode_morse = 7'b0111000; // Q (--.-)
                {3'd3, 5'b00101}: decode_morse = 7'b1010111; // R (.-.)
                {3'd3, 5'b00000}: decode_morse = 7'b1001001; // S (...)
                {3'd1, 5'b00001}: decode_morse = 7'b1000111; // T (-)
                {3'd3, 5'b00001}: decode_morse = 7'b1100011; // U (..-)
                {3'd4, 5'b00001}: decode_morse = 7'b1100011; // V (...-)
                {3'd3, 5'b00110}: decode_morse = 7'b1110010; // W (.--)
                {3'd4, 5'b01001}: decode_morse = 7'b0010010; // X (-..-)
                {3'd4, 5'b01011}: decode_morse = 7'b0110010; // Y (-.--)
                {3'd4, 5'b01100}: decode_morse = 7'b0100100; // Z (--..)
                // Numere
                {3'd5, 5'b11111}: decode_morse = 7'b1000000; // 0 (-----)
                {3'd5, 5'b01111}: decode_morse = 7'b1111001; // 1 (.----)
                {3'd5, 5'b00111}: decode_morse = 7'b0100100; // 2 (..---)
                {3'd5, 5'b00011}: decode_morse = 7'b0110000; // 3 (...--)
                {3'd5, 5'b00001}: decode_morse = 7'b0011001; // 4 (....-)
                {3'd5, 5'b00000}: decode_morse = 7'b0010010; // 5 (.....)
                {3'd5, 5'b10000}: decode_morse = 7'b0000010; // 6 (-....)
                {3'd5, 5'b11000}: decode_morse = 7'b1111000; // 7 (--...)
                {3'd5, 5'b11100}: decode_morse = 7'b0000000; // 8 (---..)
                {3'd5, 5'b11110}: decode_morse = 7'b0010000; // 9 (----.)
                default: decode_morse = 7'b1111111; 
            endcase
        end
    endfunction

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S_IDLE;
        end else begin
            state <= next_state;
        end
    end

    
    always @(*) begin
        next_state = state;
        case (state)
            S_IDLE: begin
                
                if (btn_pressed) begin
                    timer = 0;
                    next_state = S_PRESSED;
                end
            end

            S_PRESSED: begin
               
                if (btn_pressed) begin
                    if (timer < DASH_LIMIT) begin
                        timer = timer + 1;
                    end
                end else begin
                   
                    if (sequence_len < 5) begin
                        sequence_len = sequence_len + 1;
                        morse_sequence = morse_sequence << 1;
                        if (timer < DOT_LIMIT) begin
                           
                            morse_sequence[0] = 0;
                        end else begin
                           
                            morse_sequence[0] = 1;
                        end
                    end
                    timer = 0;
                    next_state = S_RELEASED;
                end
            end

            S_RELEASED: begin
                
                if (!btn_pressed) begin
                    if (timer < WORD_GAP_LIMIT) begin
                        timer = timer + 1;
                    end else begin
                        
                        char_code = 7'b1111111; 
                        sequence_len = 0;
                        morse_sequence = 0;
                        next_state = S_IDLE;
                    end

                    
                    if (timer > LETTER_GAP_LIMIT && sequence_len > 0) begin
                        
                        char_code = decode_morse(sequence_len, morse_sequence);
                        sequence_len = 0;
                        morse_sequence = 0;
                       
                    end
                end else begin
                    
                    timer = 0;
                    next_state = S_PRESSED;
                end
            end
        endcase
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            timer <= 0;
            morse_sequence <= 0;
            sequence_len <= 0;
            char_code <= 7'b1111111; 
        end
    end

endmodule