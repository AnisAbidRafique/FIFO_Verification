class fifo_sequence extends uvm_sequence #(fifo_seq_item);
  
  // Required macro for sequences automation
  `uvm_object_utils(fifo_sequence)

  // Constructor
  function new(string name="fifo_sequence");
    super.new(name);
    `uvm_info(get_type_name(),"Inside fifo base sequence constructor",UVM_LOW)
  endfunction

  task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask : pre_body

task body();
    `uvm_info(get_type_name(), "Executing fifo_reset_seq sequence", UVM_LOW)
    //  repeat(5)
      
      // `uvm_do(req)
  endtask


  task post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body

endclass : fifo_sequence

//------------------------------------------------------------------------------
//
// SEQUENCE: yapp_5_packets
//
//  Configuration setting for this sequence
//    - update <path> to be hierarchial path to sequencer 
//
//  uvm_config_wrapper::set(this, "<path>.run_phase",
//                                 "default_sequence",
//                                 yapp_5_packets::get_type());
//
//------------------------------------------------------------------------------
class fifo_reset_seq extends fifo_sequence;
  
  // Required macro for sequences automation
  `uvm_object_utils(fifo_reset_seq)

  // Constructor
  function new(string name="fifo_reset_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing fifo_reset_seq sequence", UVM_LOW)
    //  repeat(5)
      `uvm_do_with(req,{rst_n == 0;})
      // `uvm_do(req)
  endtask
  
endclass : fifo_reset_seq

class fifo_full_flag_seq extends fifo_sequence;
  
  // Required macro for sequences automation
  `uvm_object_utils(fifo_full_flag_seq)

  // Constructor
  function new(string name="fifo_full_flag_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing fifo_full_flag_seq sequence", UVM_LOW)
     `uvm_do_with(req,{rst_n == 0;r_en == 0;w_en == 0;})
     repeat(8)
      `uvm_do_with(req,{rst_n == 1;r_en == 0;w_en == 1;})
  endtask
  
endclass : fifo_full_flag_seq



class fifo_empty_flag_seq extends fifo_sequence;
  // Required macro for sequences automation
  `uvm_object_utils(fifo_empty_flag_seq)

  // Constructor
  function new(string name="fifo_empty_flag_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing fifo_empty_flag_seq sequence", UVM_LOW)
     repeat(8)
      `uvm_do_with(req,{rst_n == 1;r_en == 1;w_en == 0;})
  endtask
  
endclass : fifo_empty_flag_seq

class fifo_RAW_directed_seq extends fifo_sequence;
  // Required macro for sequences automation
  `uvm_object_utils(fifo_RAW_directed_seq)

  // Constructor
  function new(string name="fifo_RAW_directed_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing fifo_RAW_directed_seq sequence", UVM_LOW)
     `uvm_do_with(req,{rst_n == 0;r_en == 0;w_en == 0;})
     repeat(9)begin
      `uvm_do_with(req,{rst_n == 1;data_in == 5;r_en == 0;w_en == 1;})
      `uvm_do_with(req,{rst_n == 1;r_en == 1;w_en == 0;})end
  endtask
  
endclass : fifo_RAW_directed_seq

class fifo_RAW_random_seq extends fifo_sequence;
  // Required macro for sequences automation
  `uvm_object_utils(fifo_RAW_random_seq)

  // Constructor
  function new(string name="fifo_RAW_random_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing fifo_RAW_random_seq sequence", UVM_LOW)
     `uvm_do_with(req,{rst_n == 0;r_en == 0;w_en == 0;})
     repeat(9)begin
      `uvm_do_with(req,{rst_n == 1;r_en == 0;w_en == 1;})
      `uvm_do_with(req,{rst_n == 1;r_en == 1;w_en == 0;})end
  endtask
  
endclass : fifo_RAW_random_seq

class fifo_exhaustive_seq extends  fifo_sequence;
    fifo_full_flag_seq            myseq_1;
    fifo_empty_flag_seq           myseq_2;
    fifo_RAW_directed_seq         myseq_3;
    fifo_RAW_random_seq           myseq_4;
    // yapp_incr_payload_seq  myseq_5;

// Required macro for sequences automation
  `uvm_object_utils(fifo_exhaustive_seq)
// Constructor
  function new(string name="fifo_exhaustive_seq");
    super.new(name);
  endfunction
    
// Sequence body definition
  virtual task body();
  `uvm_info(get_type_name(),"Building fifo_exhaustive_seq",UVM_LOW)
        `uvm_do(myseq_1)
        `uvm_do(myseq_2)
        `uvm_do(myseq_3)
        `uvm_do(myseq_4)
        // `uvm_do(myseq_5)  
        // `uvm_do_with(myseq_1,{myseq_1.srb_control_bit == 1;})
  endtask
endclass : fifo_exhaustive_seq