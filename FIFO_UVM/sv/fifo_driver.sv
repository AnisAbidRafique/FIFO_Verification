class fifo_driver extends uvm_driver#(fifo_seq_item);

`uvm_component_utils(fifo_driver)

  virtual fifo_interface vif;

  fifo_seq_item item;

    function new (string name = "fifo_driver",uvm_component parent);
        super.new(name,parent);
        `uvm_info(get_type_name(),"Inside fifo driver constructor",UVM_HIGH)
    endfunction

    //build phase
   function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     if(!uvm_config_db#(virtual fifo_interface)::get(this,"", "vif",vif))
      `uvm_fatal("No vif found", {"virtual interface must be set for: ",get_full_name(),".vif"});
    endfunction: build_phase

    task run_phase(uvm_phase phase);

        forever 
        begin
            item = fifo_seq_item::type_id::create("item");
            seq_item_port.get_next_item(item);
            drive(item);
            seq_item_port.item_done();
        end
    endtask


    function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(),"I am here",UVM_HIGH)
    endfunction

    //--------------------------------------------------------
  //[Method] Drive
  //--------------------------------------------------------
  task drive(fifo_seq_item item);
    @(negedge vif.clock);
    vif.rst_n   <= item.rst_n;
    vif.r_en    <= item.r_en;
    vif.data_in <= item.data_in;
    vif.w_en    <= item.w_en;
    seq_item_port.put(item);
    // `uvm_info(get_type_name(), $sformatf("Sending Packet :\n%s", item.sprint()), UVM_LOW)
  endtask: drive
endclass