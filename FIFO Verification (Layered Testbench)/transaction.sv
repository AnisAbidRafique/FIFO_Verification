class transaction#(parameter DEPTH=8, DATA_WIDTH=8);

bit w_en,r_en;
rand bit [DATA_WIDTH - 1: 0] data_in;

bit [DATA_WIDTH - 1: 0] data_out;
bit full,empty,rst_n;

// constraint c1 {w_en != r_en;}


function new(bit [DATA_WIDTH - 1 :0] data_in = 0);

this.data_in    = data_in;

endfunction

task display();
    $display("Data_in = %d, write_enable = %d,read_enable = %d, full flag = %d, Empty flag = %d, Reset signal = %d",data_in,w_en,r_en,full,empty,rst_n);
endtask

function transaction copy();
    copy = new();
    copy.data_in    = this.data_in;
    copy.data_out   = this.data_out;
    copy.full       = this.full;
    copy.empty      = this.empty;
    copy.r_en       = this.r_en;
    copy.w_en       = this.w_en;
    copy.rst_n      = this.rst_n;

endfunction 
    
endclass