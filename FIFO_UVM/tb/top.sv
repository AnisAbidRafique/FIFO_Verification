module top;
// import the UVM library
// include the UVM macros
 import uvm_pkg::*;
 `include "uvm_macros.svh"

// import the FIFO package
 import fifo_pkg::*;
 `include "fifo_tb.sv"
 `include "fifo_test_lib.sv"  

logic clock;

fifo_interface intf(.clock(clock));

synchronous_fifo #(.DEPTH(), .DATA_WIDTH())
dut
(
    .clk(intf.clock),
    .rst_n(intf.rst_n),
    .w_en(intf.w_en),
    .r_en(intf.r_en),
    .data_in(intf.data_in),
    .data_out(intf.data_out),
    .full(intf.full),
    .empty(intf.empty)
  );

initial
begin
    uvm_config_db #(virtual fifo_interface)::set(null, "*", "vif", intf );
end

//--------------------------------------------------------
  //Start The Test
  //--------------------------------------------------------
  initial begin
    run_test("FIFO_test");
  end

//--------------------------------------------------------
  //Clock Generation
  //--------------------------------------------------------
  initial begin
    clock = 0;
    #5;
    forever begin
      clock = ~clock;
      #2;
    end
  end

  //--------------------------------------------------------
  //Maximum Simulation Time
  //--------------------------------------------------------
  initial begin
    #500000;
    $display("Sorry! Ran out of clock cycles!");
    $finish();
  end



endmodule : top
