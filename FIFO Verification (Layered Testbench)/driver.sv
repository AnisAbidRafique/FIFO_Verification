class driver#(parameter DEPTH=8, DATA_WIDTH=8);

virtual fifo_interface #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH)) fifo_itf;
mailbox #(transaction #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH))) mbx;
transaction #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH)) data;


int trans_rec;

function new(mailbox #(transaction #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH))) mbx,virtual fifo_interface #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH)) fifo_itf);
    this.mbx = mbx;
    this.fifo_itf = fifo_itf;
    trans_rec = 0;
endfunction

task run();
forever
begin
    mbx.get(data);
    @(negedge fifo_itf.clk);
    fifo_itf.w_en       <= data.w_en;
    fifo_itf.r_en       <= data.r_en;
    fifo_itf.data_in    <= data.data_in;
    fifo_itf.rst_n      <= data.rst_n;
    // if(!data.rst_n) $display($time, "[DRIVER]RESET DRIVEN");
    // $display("driver =  %d",trans_rec);
    $display("Total no of transactions %d", trans_rec);  
    trans_rec++;
    // @(negedge fifo_itf.clk);
end
    
endtask
    
endclass