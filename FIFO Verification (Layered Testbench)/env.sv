class environment#(parameter DEPTH=8, DATA_WIDTH=8);

    virtual fifo_interface #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH)) fifo_itf;
    mailbox#(transaction #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH))) mon2scb;
    mailbox#(transaction #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH))) gen2driv;
    mailbox#(transaction #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH))) gen2scb;

    driver #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH)) mydriver;
    monitor #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH))mymonitor;
    scoreboard #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH)) myscb;
    generator #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH)) mygen;

    int local_wait;

    function new(virtual fifo_interface #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH)) fifo_itf,int count,int test_select);
        mon2scb     = new();
        gen2driv    = new();
        gen2scb     = new();
        this.fifo_itf = fifo_itf;

        mydriver    = new(gen2driv,fifo_itf);
        mygen       = new(gen2driv,gen2scb,count,test_select);
        mymonitor   = new(mon2scb,fifo_itf);
        myscb       = new(mon2scb,gen2scb);

    case (test_select)
        0 :  local_wait = 1;                //reset(); // 1
        1 :  local_wait = 2 + DEPTH;        //reset(); //1 full_flag_test(); // DEPTH
        2 :  local_wait = 3 + (2*DEPTH);    //reset(); //1 full_flag_test();  //DEPTH Empty_flag_test(); //DEPTH
        3 :  local_wait = 1 + (count*4);        //reset_check(); //count * 4
        4 :  local_wait = 1 + (2* count);   //reset(); // 1 read_after_write_test(); // count * 2
        5 :  local_wait = 1 + (2* count);   //reset(); // 1 read_after_write_random_test(); // count * 2
        6 :  local_wait = 41+ (2*DEPTH);    //reset(); // 1 depth_check(); // 2*DEPTH + 40

        default : $display("Kindly select the valid test case. Thanks");
    endcase

        
    endfunction

    task test();
        fork
            mydriver.run();
            mygen.run();
            mymonitor.run();
            myscb.run();
        join_any
    endtask

    task post_test();

    $display("POST TEST");
// && mygen.count == myscb.trans_rx 
    wait((mygen.tx_success == 1) && (local_wait == (myscb.trans_rx))) 
    begin
        if(myscb.error_count > 0)
            $display("Failed!!!! Error count = %d",myscb.error_count);
        else
            $display("Test Pass");
        
    end
    endtask

    task run();

        test();
        post_test();
        // $finish;
    endtask

    
endclass