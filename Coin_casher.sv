module CoinCahser (
    input   clk, power, stick_up, stick_down, stick_left, stick_right, stick_in,
            coin_inserted, return_coin, 
    input   [3:0] coin_num_per_round, coins_to_insert, wait_time_for_insert,  // from intialization state 
    output  [2:0] stick_direction, 
    output  stick_en    // output flags
);
    
endmodule

