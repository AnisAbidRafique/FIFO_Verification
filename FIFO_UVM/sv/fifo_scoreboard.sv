class fifo_scoreboard extends uvm_scoreboard;

  int local_fifo[$];
  
  `uvm_component_utils_begin(fifo_scoreboard)
    `uvm_field_queue_int(local_fifo, UVM_ALL_ON)
  `uvm_component_utils_end
  
  uvm_analysis_imp #(fifo_seq_item, fifo_scoreboard) scoreboard_port;
  

  int error_count;

  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "fifo_scoreboard", uvm_component parent);
    super.new(name, parent);
    scoreboard_port = new("scoreboard_port", this);
    `uvm_info("SCB_CLASS", "Inside Constructor!", UVM_HIGH)
  endfunction: new
  //--------------------------------------------------------
  //Build Phase
  //--------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("SCB_CLASS", "Build Phase!", UVM_HIGH)
   
    
  endfunction: build_phase
  //--------------------------------------------------------
  //Write Method
  //--------------------------------------------------------
  function void write(fifo_seq_item mon_item);
  int curr_trans;
  fifo_seq_item item;
  $cast(item,mon_item.clone());
  $display("[SCOREBOARD] Current transaction");
  item.print();
  
  
  if(item.w_en && local_fifo.size() < 8)
    begin
      if(local_fifo.size() < 8)
        begin
            local_fifo.push_back(item.data_in);
        end
      else
        begin
          $display("Cant write the fifo is full");
        end
    end
  if(item.r_en == 1)
    begin
        if(local_fifo.size() !== 0) 
          begin
              curr_trans = local_fifo.pop_front();
              
              fifo_checker(item.data_out,curr_trans);
          end
        else  
          begin
            $display("Cant read the fifo is empty");
          end
    end
  // $display("[SCOREBOARD] Current local fifo size %d",local_fifo.size());
  this.print();
///////////////////////////////
///////asserition//////////////
///////////////////////////////
if(!item.rst_n) 
begin
  assert (item.empty)
  else
      begin
      $display("Empty flag %d asserition failed reset signal %d",item.empty,item.rst_n);
      error_count ++;
      end
end
  if(local_fifo.size() == 8) 
  begin
      assert (item.full)
  else
      begin
        
      $display("Full flag %d asserition failed",item.full);
      error_count ++;
      end
  end

  if(local_fifo.size() == 0) 
  begin
    assert (item.empty)
    else   
      begin
      $display("Empty flag %d asserition failed ",item.empty);
      error_count ++;
      end
  end


  endfunction: write 

 task fifo_checker(input [8 - 1:0]actual,expected);
    if(actual !== expected)
        begin
            $display ( "Read Data is =%d, should be %d", actual, expected);
            error_count ++;
        end
endtask 
  
 function void report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),$sformatf("------ :: TOTOL Errors:: ------%d",error_count),UVM_LOW)
 endfunction
endclass: fifo_scoreboard