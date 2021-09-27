module CoinCahser (
    input   clk, return_coin, timer_finish, coin_insert, game_finish, // "coin_insert" is high when coin is inserted into the arcade machine 
    input   [2:0] inserted_coin,          // "inserted_coin" tells the Denomination of the coin, 0001 for 5 cents, 010 for 10 cents, 011 for 25 cents, 100 for 1 dollar, 101 for 2 dollar 
    //output  [2:0] stick_direction,    
    output  timer_en, coin_reject, eat_coins, reset_timer, spit_coin, wait_ready    // output flags
);
    state [11:0] = 12'b0;
    parameter power_on          = 12'b0;
    parameter wait_game_start   = 12'b1;
    parameter check_coin        = 12'b10;
    parameter spit_all_coin     = 12'b100;
    parameter check_coin_num    = 12'b1000;
    parameter reject_coin       = 12'b10000;
    parameter start_game        = 12'b100000;
    //parameter check_fir_coin    = 12'b1000000;
    parameter wait_game_fin     = 12'b10000000;
    parameter start_timer       = 12'b100000000;
    parameter incr_coin_count   = 12'b1000000000;

    logic [3:0] coin_counter = 4'd0;    // typical arcade machine accepts no more than 8 coins, default setting: accept 2 coins to start 

    // state transition 
    always_ff @(posedge clk) begin 
        case(state)
            power_on:       state <= wait_game_start;
            wait_game_start: begin
                if(return_coin || timer_finish)
                    state <= spit_all_coin;
                else if(coin_insert)
                    state <= check_coin;
                else
                    state <= wait_game_start;
            end
            check_coin: begin
                if(inserted_coin == 3'b100) // default setting: the machine only accept 1 dollar coin
                    state <= check_coin_num;
                else
                    state <= reject_coin;
            end
            spit_all_coin:  state <= wait_game_start;
            check_coin_num: begin
                if((coin_counter + 1'b1) == 4'd2)   // since non-blocking assignment, here need to compare "coin_counter + 1"
                    state <= start_game;
                else if ((coin_counter + 1'b1) == 4'd1)
                    state <= start_timer;
                else 
                    state <= incr_coin_count;
            end
            reject_coin:    state <= wait_game_start;
            start_game:     state <= wait_game_fin;
            //check_fir_coin:
            wait_game_fin:  state <= game_finish ? wait_game_start : wait_game_fin;
            start_timer:    state <= incr_coin_count;
            incr_coin_count: state <= wait_game_start;
            default:
        endcase
    end

    // FSM outputs
    assign timer_en     = state[8];
    assign coin_reject  = state[4];
    assign eat_coins    = state[5];
    assign reset_timer  = state[5] || state[2];
    assign spit_coin    = state[2];
    assign wait_ready   = state[0]; // tell the insert coin module to start detect coins 

endmodule

// module that detect coin and tell the main FSM coin type + flag
// module insercoin (
//     input clk, en, 
//     output coin_insert,
//     output [2:0] coin_type
// );
//      ...
// endmodule

// this module helps the FSM to count down, who wait for the customer to insert the rest of the coin
// the parameter makes this FSM count 60s in default (depends on clk frquency)
// module timer #(
//     parameter count = ...
// ) (
//     input clk, en, rst,
//     output timer_fin
// );
    
// endmodule