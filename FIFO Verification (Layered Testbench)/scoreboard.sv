class scoreboard#(parameter DEPTH=8, DATA_WIDTH=8);
    mailbox#(transaction #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH))) mon2scb;
    mailbox#(transaction #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH))) gen2scb;
    transaction #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH))gen2scb_tx;
    transaction #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH))mon2scb_tx;


    int trans_rx,error_count;
    int local_counter;
    logic [DATA_WIDTH-1:0] temp_mem [$];
    int r_ptr,wr_ptr,local_empty=0,local_full=0;
    

    function new(mailbox#(transaction #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH))) mon2scb,mailbox#(transaction #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH))) gen2scb);
        this.mon2scb = mon2scb;
        this.gen2scb = gen2scb;
        r_ptr = 0;
        wr_ptr = 0;
    endfunction
     
   task run();
        $display("INSIDE SCOREBOARD CLASS [SCOREBOARD]");
    forever 
    begin
        mon2scb.get(mon2scb_tx);
        gen2scb.get(gen2scb_tx);
        // mon2scb_tx.display();

        
        mon2scb_tx.display();
        
        if(!mon2scb_tx.rst_n)
            begin
                // $display("Doing nothing because of reset...");
                assert (mon2scb_tx.empty) $display("Empty flag %d asserition passed ",mon2scb_tx.empty);
                else   
                begin
                $display("Empty flag %d asserition failed ",mon2scb_tx.empty);
                error_count ++;
                end
                
            end
        

        if(gen2scb_tx.w_en && local_full)
            begin
                assert (mon2scb_tx.full) $display("Full flag %d asserition passed ",mon2scb_tx.full);
                else
                begin
                $display("Full flag %d asserition failed ",mon2scb_tx.full);
                error_count ++;
                end
                   

            end

        else if (gen2scb_tx.w_en && !local_full) 
            begin
                temp_mem[wr_ptr] = gen2scb_tx.data_in;
                wr_ptr++;
                local_counter++;
            end
            
        if(mon2scb_tx.r_en && local_empty)
            begin
                assert (mon2scb_tx.empty) $display("Empty flag %d asserition passed ",mon2scb_tx.empty);
                else   
                begin
                $display("Empty flag %d asserition failed ",mon2scb_tx.empty);
                error_count ++;
                end
            end

        else if (mon2scb_tx.r_en && !local_empty) 
            begin
                fifo_checker(mon2scb_tx.data_out,temp_mem[r_ptr]);
                // $display("Actual data %d,Expected  %d",mon2scb_tx.data_out,temp_mem[r_ptr]);
                r_ptr++;
                local_counter--;
            end
        local_empty =  (r_ptr == wr_ptr) ? 1 : 0;
        local_full  =  (local_counter == DEPTH) ? 1 : 0;
    trans_rx ++;


        
        // $display("local Full flag %d asserition passed,local counter %d , rd ptr: %d, wr ptr %d",local_full , local_counter, r_ptr, wr_ptr);
        // $display("Full flag %d asserition passed ",mon2scb_tx.full);

    // $display("scoreboard %d",trans_rx);
    end
        
    endtask

task fifo_checker(input [DATA_WIDTH - 1:0]actual,expected);
    if(actual !== expected)
        begin
            $display ( "Read Data is =%d, should be %d", actual, expected);
            error_count ++;
        end
endtask 

endclass