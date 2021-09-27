module startup_page (
    input   clk, stick_en,
    input   [2:0] stick_direction,
    output  [3:0] coin_num_per_round, coins_to_insert, wait_time_for_insert
);
    parameter state [3:0] = 6'b0;
    parameter wait_stick    = 6'b000001;
    parameter stick_up      = 6'b000010;
    parameter stick_down    = 6'b000100;
    parameter stick_left    = 6'b001000;
    parameter stick_right   = 6'b010000;
    parameter init_done     = 6'b100000;

    logic   [3:0] count_value = 4'd0;
    
    always_ff @(posedge clk) begin
        case(state)
            wait_stick: begin
                if(stick_direction == 3'b000)   // up
                    state <= stick_up;
                else if(stick_direction == 3'b001)
                    state <= stick_down;
                else if(stick_direction == 3'b010)
                    state <= stick_left; 
                else if(stick_direction == 3'b011)
                    state <= stick_right; 
                else if(stick_direction == 3'b100)
                    state <= init_done; 
                else
                    state <= wait_stick;
            end
            stick_up:   begin
                state <= wait_stick;
                coin_num_per_round <= coin_num_per_round - 4'd5;
            end
            stick_down:
            stick_left:
            stick_right:
            stick_in:
            default:
        endcase
    end
    
endmodule