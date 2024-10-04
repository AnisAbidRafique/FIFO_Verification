class monitor#(parameter DEPTH=8, DATA_WIDTH=8);

    virtual fifo_interface #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH))fifo_itf;
    mailbox #(transaction#(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH))) mbx;
    transaction #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH))trans;

    function new(mailbox #(transaction #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH))) mbx,virtual fifo_interface #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH)) fifo_itf);

    this.mbx = mbx;
    this.fifo_itf = fifo_itf;
    trans = new();
    endfunction

    task run();
    fork
        // check_reset();
        begin 
            // $display("INSIDE MONITOR CLASS [MONITOR]");
            forever 
            begin
                @(posedge fifo_itf.clk);              
                trans.w_en      = fifo_itf.w_en;
                trans.r_en      = fifo_itf.r_en ;
                trans.data_in   = fifo_itf.data_in;
                trans.rst_n     = fifo_itf.rst_n;
                @(negedge fifo_itf.clk);
                trans.data_out  = fifo_itf.data_out;
                trans.full      = fifo_itf.full;
                trans.empty     = fifo_itf.empty;
                // $display($time,"MONITOR EMPTY FLAG = %d", fifo_itf.empty);
                mbx.put(trans.copy());
                // trans.display();
                // $display($time , " ,Monitor=====");
                // trans.display();

                
            end    
        end
    join
    endtask

    // task check_reset();
    //     $display($time, "Started Reset Check");   
    //     wait(!fifo_itf.rst_n)
    //     begin 
    //         $display("Reset Captured");
    //     end
    // endtask

    
endclass