`include "fifo_interface.sv"
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "env.sv"

module top#(parameter DEPTH=8, DATA_WIDTH=8);
// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 1ns;

///classes///
environment #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH)) myenv;
//////////////////

// SYSTEMVERILOG: logic and bit data types
bit         clk;

always #5 clk = ~clk;


fifo_interface  #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH))
           fifo_itf (clk);


// SYSTEMVERILOG:: implicit .name port connections
synchronous_fifo  #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH))
           first_in_out (.fif(fifo_itf.fifo_mod));

int rep_count,test_case;

covergroup cg @(posedge clk);
cpa : coverpoint fifo_itf.data_in
{
    option.at_least = 10;
}
cpb : coverpoint {fifo_itf.w_en,fifo_itf.r_en}
{
    option.at_least = 5;
}
endgroup

initial
begin
    cg cg_inst = new();
    rep_count = 9;
    test_case = 3; //[1-6]
    // myenv = new(fifo_itf,rep_count,test_case);
    // myenv.run();

    myenv = new(fifo_itf,rep_count,1);
    myenv.run();
    myenv = new(fifo_itf,rep_count,2);
    myenv.run();
    myenv = new(fifo_itf,rep_count,3);
    myenv.run();
    myenv = new(fifo_itf,rep_count,4);
    myenv.run();
    myenv = new(fifo_itf,rep_count,5);
    myenv.run();
    myenv = new(fifo_itf,rep_count,6);
    myenv.run();
    $finish;
end



  initial 
  begin
    $dumpfile("dump.vcd");
    $dumpvars;
      #4000000ns $display ( "FIFO TEST TIMEOUT" );
      $finish;
    end

endmodule
