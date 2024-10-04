interface fifo_interface #(parameter DEPTH=8, DATA_WIDTH=8) 
(
  input logic clk
);
timeunit 1ns;
timeprecision 1ns;
  logic w_en, r_en;
  logic [DATA_WIDTH-1:0] data_in;
  logic [DATA_WIDTH-1:0] data_out;
  logic full, empty,rst_n;

  modport fifo_mod 
  (
    input clk,rst_n,w_en,r_en,data_in,
    output data_out,full,empty
  );

endinterface : fifo_interface
