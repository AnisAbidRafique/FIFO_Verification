class fifo_sequencer extends uvm_sequencer#(fifo_seq_item);

`uvm_component_utils(fifo_sequencer)

    function new (string start_of_simulation_phase = "fifo_sequencer",uvm_component parent);
        super.new(start_of_simulation_phase,parent);
    `uvm_info(get_type_name(),"Inside fifo sequencer constructor",UVM_HIGH)
    endfunction

    function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"FIFO I am here",UVM_HIGH)
    endfunction

endclass