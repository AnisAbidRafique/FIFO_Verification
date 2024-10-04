class fifo_monitor extends uvm_monitor;

`uvm_component_utils(fifo_monitor)

  virtual fifo_interface vif;
  fifo_seq_item item;
  uvm_analysis_port #(fifo_seq_item) monitor_port;

    function new (string name = "fifo_monitor",uvm_component parent);
        super.new(name,parent);
        monitor_port = new("monitor_port", this);
    `uvm_info(get_type_name(),"Inside fifo constructor",UVM_HIGH)
    endfunction

// Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual fifo_interface)::get(this, "", "vif", vif))
      `uvm_fatal("No vif found", {"virtual interface must be set for: ", get_full_name(), ".vif"});
  endfunction

    //--------------------------------------------------------
  //Run Phase
  //--------------------------------------------------------
  task run_phase (uvm_phase phase);
    // phase.raise_objection(this, get_type_name());
    super.run_phase(phase);
    `uvm_info("MONITOR_CLASS", "Inside Run Phase!", UVM_LOW)
    @(negedge vif.clock);
    forever begin
      item = fifo_seq_item::type_id::create("item");
      
    //   wait(!vif.reset);
      
      //sample inputs
      @(posedge vif.clock);
      item.w_en     = vif.w_en;
      item.r_en     = vif.r_en;
      item.data_in  = vif.data_in;
      item.rst_n    = vif.rst_n;
      
      //sample output
      @(negedge vif.clock);
      item.data_out = vif.data_out;
      item.full     = vif.full;
      item.empty    = vif.empty;
      
      // send item to scoreboard
      monitor_port.write(item);
      `uvm_info(get_type_name(), $sformatf("Sending Packet :\n%s", item.sprint()), UVM_LOW)
    //   phase.drop_objection(this, get_type_name());
    end
        
  endtask: run_phase

    function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"I am here",UVM_HIGH)
    endfunction

endclass