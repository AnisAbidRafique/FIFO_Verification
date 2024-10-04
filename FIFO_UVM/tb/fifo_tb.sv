class router_fifo_env extends uvm_env;

`uvm_component_utils(router_fifo_env)
virtual fifo_interface vif;
fifo_env my_env;

    function new (string name = "router_fifo_env",uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);
        my_env = fifo_env::type_id::create("my_env",this);
        //configurations
        `uvm_info(get_type_name(),"I am in Router ENV",UVM_HIGH)
        uvm_config_db#(virtual fifo_interface)::set(this, "my_env", "vif", vif);
        if(!uvm_config_db#(virtual fifo_interface)::get(this,"", "vif",vif))
            `uvm_fatal("No vif found", {"virtual interface must be set for: ",get_full_name(),".vif"});
    endfunction

    function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"I am here",UVM_HIGH)
    endfunction

endclass