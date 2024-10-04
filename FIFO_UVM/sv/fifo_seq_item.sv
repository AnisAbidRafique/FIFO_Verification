class fifo_seq_item extends uvm_sequence_item;
    //define protocol data
    rand bit w_en,r_en;
    rand bit [7 : 0] data_in;

    bit [7 : 0] data_out;
    bit full,empty;
    rand bit rst_n;

    // Enable automation of the packet's fields
  `uvm_object_utils_begin (fifo_seq_item )
  `uvm_field_int          (w_en,UVM_ALL_ON )
  `uvm_field_int          (r_en,UVM_ALL_ON )
  `uvm_field_int          (data_in,UVM_ALL_ON)
  `uvm_field_int          (data_out,UVM_ALL_ON)
  `uvm_field_int          (full,UVM_ALL_ON )
  `uvm_field_int          (empty,UVM_ALL_ON )
  `uvm_field_int          (rst_n,UVM_ALL_ON )

  `uvm_object_utils_end

  // constraint c1{w_en!=r_en;}
    // Define packet constraints

    // Add methods for parity calculation and class construction
  function new (string name = "fifo_seq_item");
    super.new(name);
    `uvm_info(get_type_name(),"Inside fifo sequence constructor",UVM_HIGH)
  endfunction

endclass: fifo_seq_item