class fifo_env extends uvm_env;

`uvm_component_utils(fifo_env)
fifo_agent my_agent;
fifo_scoreboard my_scb;
virtual fifo_interface vif;

    function new (string name = "fifo_env",uvm_component parent);
        super.new(name,parent);
    `uvm_info(get_type_name(),"Inside fifo env constructor",UVM_HIGH)
    endfunction

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);
        `uvm_info(get_type_name(),"Building FIFO ENV",UVM_HIGH)
        my_agent = fifo_agent::type_id::create("my_agent",this);
        my_scb   = fifo_scoreboard::type_id::create("my_scb",this);
        
        uvm_config_db#(virtual fifo_interface)::set(this, "my_agent", "vif", vif);
        uvm_config_db#(virtual fifo_interface)::set(this, "my_scb", "vif", vif);
        if(!uvm_config_db#(virtual fifo_interface)::get(this,"", "vif",vif))
          `uvm_fatal("No vif found", {"virtual interface must be set for: ",get_full_name(),".vif"});
    endfunction

    //--------------------------------------------------------
  //Connect Phase
  //--------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("ENV_CLASS", "Connect Phase!", UVM_HIGH)
    
    my_agent.my_monitor.monitor_port.connect(my_scb.scoreboard_port);
    
  endfunction: connect_phase

    function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"I am here",UVM_HIGH)
    endfunction

endclass