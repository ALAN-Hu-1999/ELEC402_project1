module coin_casher_tb();
    wire    clk_tb, return_coin_tb, timer_finish_tb, coin_insert_tb, game_finish_tb;
    wire    [2:0] inserted_coin_tb;
    wire    timer_en_tb, coin_reject_tb, eat_coins_tb, reset_timer_tb, spit_coin_tb, wait_ready_tb;

    CoinCahser DUT1(
        clk_tb, return_coin_tb, timer_finish_tb, coin_insert_tb, game_finish_tb, 
        inserted_coin_tb,          
        timer_en_tb, coin_reject_tb, eat_coins_tb, reset_timer_tb, spit_coin_tb, wait_ready_tb
    );

    initial forever begin
        clk_tb = 1'b0;  #5;
        clk_tb = 1'b1;  #5;
    end

    initial begin
        // testing FSM with no input on high, the state should remain in "wait_game_start"
        return_coin_tb  = 1'b0;
        timer_finish_tb = 1'b0;
        coin_insert_tb  = 1'b0;
        game_finish_tb  = 1'b0;
        inserted_coin   = 3'b0;
        #10;
        $stop;
    end
endmodule