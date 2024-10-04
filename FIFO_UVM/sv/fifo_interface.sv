interface fifo_interface
(
  input clock
);
  bit w_en, r_en,rst_n;
  bit [8 - 1:0] data_in;
  bit [8 - 1:0] data_out;
  bit full, empty;


endinterface : fifo_interface