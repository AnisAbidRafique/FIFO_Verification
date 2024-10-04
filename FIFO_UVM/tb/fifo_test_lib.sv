class base_test extends  uvm_test;

`uvm_component_utils(base_test)

    function new (string name = "base_test",uvm_component parent);
        super.new(name,parent);
    endfunction

    fifo_env tb;

    function void build_phase(uvm_phase phase);

        // //transaction recording
        // uvm_config_int::set( this, "*", "recording_detail", 1);

        super.build_phase(phase);
        // uvm_config_wrapper::set(this, "router_tb.yapp_env.yapp_agent.yapp_sequencer.run_phase",
        //                             "default_sequence",
        //                             yapp_5_packets::get_type());
        // tb = new("router_tb",this);
        tb = fifo_env::type_id::create("fifo_env",this);


        //configurations
        `uvm_info(get_type_name(),"I am in Fifo TEST",UVM_HIGH)
        
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);

    uvm_top.print_topology();
        
    endfunction

    function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"I am here",UVM_HIGH)
    endfunction

    function void check_phase (uvm_phase phase);
        check_config_usage();
    endfunction

        task run_phase(uvm_phase phase);
        uvm_objection obj = phase.get_objection();
        obj.set_drain_time(this, 4ns);
    endtask

endclass

class fifo_exhaustive_test extends  base_test;

    `uvm_component_utils(fifo_exhaustive_test)
    function new (string name = "fifo_exhaustive_test",uvm_component parent);
        super.new(name,parent);
    endfunction


    function void build_phase(uvm_phase phase);

        // set_type_override_by_type(yapp_packet :: get_type(),short_yapp_packet :: get_type());
        uvm_config_wrapper::set(this, "fifo_env.my_agent.fifo_sequencer.run_phase",
                                    "default_sequence",
                                    fifo_exhaustive_seq::get_type()); //to-do correct sequence
        super.build_phase(phase);
        
    endfunction

endclass

// class set_config_test extends base_test;

//   `uvm_component_utils(set_config_test)
//   function new (string name = "set_config_test",uvm_component parent);
//         super.new(name,parent);
//   endfunction

//   function void build_phase(uvm_phase phase);
//     uvm_config_int :: set(this,"router_tb.yapp_env.yapp_agent","is_active",UVM_PASSIVE);
//     super.build_phase(phase);
//    endfunction
// endclass

