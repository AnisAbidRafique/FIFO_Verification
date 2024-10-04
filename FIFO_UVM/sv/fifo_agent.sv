class fifo_agent extends uvm_agent;
// uvm_active_passive_enum is_active = UVM_ACTIVE;

`uvm_component_utils_begin(fifo_agent)
    `uvm_field_enum(uvm_active_passive_enum,is_active,UVM_ALL_ON)
`uvm_component_utils_end

fifo_monitor my_monitor;
fifo_driver my_driver;
fifo_sequencer my_sequencer;

    function new (string name = "fifo_agent",uvm_component parent);
        super.new(name,parent);
    `uvm_info(get_type_name(),"Inside fifo agent constructor",UVM_HIGH)

    endfunction

    function void build_phase(uvm_phase phase);

    super.build_phase(phase);
    `uvm_info(get_type_name(),"Building FIFO AGENT",UVM_HIGH)

    // my_monitor      = new();
    my_monitor = fifo_monitor::type_id::create("fifo_monitor",this);

    if(is_active == UVM_ACTIVE) 
        begin
            my_driver = fifo_driver::type_id::create("fifo_driver",this);
            my_sequencer = fifo_sequencer::type_id::create("fifo_sequencer",this);
        end
        
    endfunction

    function void connect_phase(uvm_phase phase);
            if(is_active == UVM_ACTIVE)
                my_driver.seq_item_port.connect(my_sequencer.seq_item_export);
    endfunction

    function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"I am here",UVM_HIGH)
    endfunction

endclass