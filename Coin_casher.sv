module CoinCahser (
    input   clk, return_coin, timer_finish, coin_insert, game_finish, // "coin_insert" is high when coin is inserted into the arcade machine 
    input   [2:0] inserted_coin,          // "inserted_coin" tells the Denomination of the coin, 001 for 5 cents, 010 for 10 cents, 011 for 25 cents, 100 for 1 dollar, 101 for 2 dollar 
    output  timer_en, coin_reject, eat_coins, reset_timer, spit_coin, wait_ready, game_start    // output flags
);
    state [11:0] = 12'b0;
    parameter power_on          = 12'b0;            // the start-up/fefault state
    parameter wait_game_start   = 12'b1;            // where FSM wait for coin to be inserted, theoretically the most common state the FSM stay at
    parameter check_coin        = 12'b10;           // check if the inseted coin is the desired
    parameter spit_all_coin     = 12'b100;          // return all holding coins to the player
    parameter check_coin_num    = 12'b1000;         // check the number of inserted coin 
    parameter reject_coin       = 12'b10000;        // output flag to reject the inserted coin
    parameter start_game        = 12'b100000;       // tells the game module (dont care in this project) to start 
    //parameter check_fir_coin    = 12'b1000000;
    parameter wait_game_fin     = 12'b10000000;     // wait for the game module to finish 
    parameter start_timer       = 12'b100000000;    // tell timer to start when palyer inserted the first coin
    parameter incr_coin_count   = 12'b1000000000;   // the state that increament the count of the inserted coins

    logic [3:0] coin_counter = 4'd0;    // typical arcade machine accepts no more than 8 coins, default setting: accept 2 coins to start 

    parameter desired_coin_type = 3'b100;   // default setting: the machine only accept 1 dollar coin
    parameter desired_coin_num  = 4'd3;     // default setting: the machine requires 3 x 1 dollar coin to start
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
                if(inserted_coin == desired_coin_type) 
                    state <= check_coin_num;
                else
                    state <= reject_coin;
            end
            spit_all_coin:  state <= wait_game_start;
            check_coin_num: begin
                if((coin_counter + 1'b1) == desired_coin_num)   // since non-blocking assignment, here need to compare "coin_counter + 1"
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
    assign game_finish  = state[5]

endmodule

// module that detect coin and tell the main FSM coin type + flag
// all flags is sync with the main FSM
// module insertcoin (
//     input clk, en, 
//     output coin_insert, return_coin, 
//     output [2:0] coin_type
// );
//      ...
// endmodule

// this module helps the FSM to count down, who wait for the customer to insert the rest of the coin
// the parameter makes this FSM count 60s in default (depends on clk frquency)
// all falgs is sync with the main FSM
// module timer #(
//     parameter count = ...
// ) (
//     input clk, en, rst,
//     output timer_fin
// );
    
// endmodule