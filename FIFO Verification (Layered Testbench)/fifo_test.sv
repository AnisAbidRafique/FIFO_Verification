module fifo_test #(parameter DEPTH=8, DATA_WIDTH=8)
( 
      fifo_interface fifo_test_side
);
// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 1ns;

// SYSTEMVERILOG: new data types - bit ,logic
// bit         debug = 0;
logic [DATA_WIDTH - 1 :0] rdata;      // stores data read from memory for checking
logic [DATA_WIDTH - 1 :0] rand_data;
// logic [7:0] temp;
logic [DATA_WIDTH - 1:0 ] temp_arr [DEPTH -1 : 0];
// Monitor Results
  initial begin
      $timeformat ( -9, 0, " ns", 9 );
// SYSTEMVERILOG: Time Literals
      #40000ns $display ( "FIFO TEST TIMEOUT" );
      $finish;
    end
int error_status = 0;
initial
  begin: fifotest
    //Fifo full flag test
    $display("===========================================================");
    $display("                  FIFO Full flag Test");
    $display("===========================================================\n"); 
    error_status = 0;   
    reset_fifo();  
    fifo_full_flag_test();

    //Fifo Empty Test 
    $display("===========================================================");
    $display("                  FIFO Empty flag Test");
    $display("===========================================================\n"); 
    error_status = 0;
    fifo_Empty_flag_test();

    //Read after Write test(Directed)
    $display("===========================================================");
    $display("                  FIFO RAW Test Directed");
    $display("===========================================================\n"); 
    error_status = 0;
    reset_fifo();
    repeat(25)
    begin
      read_after_write_test(rdata,4);
      $display ( "Read Data is =%d", rdata);
      fifo_checker (rdata,4);
    end
    error_check(error_status,"FIFO RAW(Directed) Test Failed!!!");

    //Read after Write test(Random)
    $display("===========================================================");
    $display("                  FIFO RAW Test Random");
    $display("===========================================================\n"); 
    error_status = 0;
    reset_fifo();
    repeat(25)
    begin
      rand_data = $random;
      read_after_write_test(rdata,rand_data);
      $display ( "Read Data is =%d", rdata);
      fifo_checker (rdata,rand_data);
    end
    error_check(error_status,"FIFO RAW(Random) Test Failed!!!");

  
    //Depth check fifo test
    $display("===========================================================");
    $display("                  FIFO depth Test");
    $display("===========================================================\n"); 
    error_status = 0;
    reset_fifo();
    depth_check();
    //Async Reset test
    $display("===========================================================");
    $display("                  FIFO Async reset Test");
    $display("===========================================================\n"); 
    error_status = 0;
    reset_fifo();
    reset_check();
    error_check(error_status,"FIFO Async reset Test Failed!!!");
$finish;

    
  end

// initial
//   begin
//     $dumpfile("dump.vcd");
//     $dumpvars;
//     #4000
//     $finish;
//   end

task reset_fifo();
    $display ("Resetting FIFO....");
    @(posedge fifo_test_side.clk) //Reseting fifo
    fifo_test_side.rst_n = 0;
    @(posedge fifo_test_side.clk)
    fifo_test_side.rst_n = 1;
endtask

task fifo_checker(input [DATA_WIDTH - 1:0]actual,expected);

  if(actual !== expected)
       begin
        $display ( "Read Data is =%d, should be %d", actual, expected);
        error_status++;
       end
  
endtask
// add result print function
task error_check (input status,input string current_str);
if (status == 0)
begin
    $display("\n");
    $display(" ______________________________oOO-{_}-OOo______________________________");
    $display("|                                                                       |");
    $display("|                               TEST PASSED                             |");
    $display("|_______________________________________________________________________|");
    $display("\n");
end
else
begin
    $display("Test Failed with %d Errors", status);
    $display ( "%s",current_str);
    $display("\n");
    $display(" ________________________________/_ __ \________________________________");
    $display("|                                                                       |");
    $display("|                               TEST FAILED                             |");
    $display("|_______________________________________________________________________|");
    $display("\n");
end
  endtask

task read_after_write_test (output [DATA_WIDTH - 1:0] r_data,input [DATA_WIDTH - 1:0] wr_data);
      fifo_test_side.write_fifo(wr_data);
      fifo_test_side.read_fifo(r_data,0);
  endtask

task fifo_full_flag_test();
  for (int i = 0; i< DEPTH; i++)
      begin
       fifo_test_side.write_fifo(i);
       if(i < (DEPTH - 1))
          fifo_checker (fifo_test_side.full,0);
      end
      fifo_checker (fifo_test_side.full,1);
      error_check(error_status,"FIFO Full flag Test Failed!!!");
endtask 

task fifo_Empty_flag_test();
  for (int i = 0; i< DEPTH; i++)
      begin
       fifo_test_side.read_fifo(rdata,0);
      // $display ( "Read Data is =%d", rdata);
      if(i < (DEPTH - 1))
       fifo_checker (fifo_test_side.empty,0);
      end
      fifo_checker (fifo_test_side.empty,1);
      error_check(error_status,"FIFO Empty flag Test Failed!!!");
endtask 

task reset_check();
  bit [DATA_WIDTH - 1 : 0]  rmem_data;
  $display ("Testing Asynchronous reset of FIFO....");
  fifo_test_side.write_fifo(15);
  @(posedge fifo_test_side.clk) //Reseting fifo
  fifo_test_side.rst_n = 0;
  fifo_test_side.read_fifo(rmem_data,0);
  fifo_checker (rmem_data,0);
  @(posedge fifo_test_side.clk)
  fifo_test_side.rst_n = 1;
  
endtask

task Random_fifo_rw_Test();
int rand_rw_sig;
[$clog2(DEPTH)-1:0] r_ptr;
bit [DATA_WIDTH - 1 : 0]  random_data;
bit [DATA_WIDTH - 1 : 0]  rmem_data;

for(int j=0;j < DEPTH;j++)
  temp_arr[j] = 0;

r_ptr = 0;

for(int i = 0; i < DEPTH;i++)
begin
rand_rw_sig = (($urandom % 2) ? 1:0);
//$display ("signal read write=%d", rand_rw_sig);

  if(rand_rw_sig)
    begin
        random_data = $urandom;
        fifo_test_side.write_fifo(random_data);
        temp_arr[i] = random_data;
        // $display ("I am in if state....");
    end
  else 
    begin
        fifo_test_side.read_fifo(rmem_data,0);
        fifo_checker (temp_arr[r_ptr],rmem_data);
        r_ptr++;
        // $display ("I am in else state....");
    end
end
endtask

task depth_check();
logic [DATA_WIDTH -1:0] data_check,data_read;

//  error_status = 0;
  for (int i = 0; i< DEPTH + 20; i++)
      begin
       fifo_test_side.write_fifo(i);
       if(i < (DEPTH - 1)) begin
        fifo_checker (fifo_test_side.full,0);
       end
          
       else begin
        fifo_checker (fifo_test_side.full,1);
       end 
      end
      fifo_checker (fifo_test_side.full,1);
      error_check(error_status,"FIFO Depth for write Test Failed!!!");

// reset_fifo();
error_status = 0;
  for (int i = 0; i< DEPTH + 20; i++)
      begin
       fifo_test_side.read_fifo(data_read,0);
      if(i < (DEPTH - 1))
       fifo_checker (fifo_test_side.empty,0);
      else if(i == (DEPTH - 1))
        begin
          data_check = data_read;
          // $display ( "Value of i(elseif) is =%d", i);
          // $display ( "Value of data read = %d and data check =%d", data_read,data_check);
          fifo_checker (fifo_test_side.empty,1);
        end
      else begin
        fifo_checker (fifo_test_side.empty,1);
        fifo_checker (data_read,data_check);
        // $display ( "Value of i(else) is =%d", i);
        // $display ( "Value of data read = %d and data check =%d", data_read,data_check);
      end
      end
      fifo_checker (fifo_test_side.empty,1);
      fifo_checker (data_read,data_check);
      error_check(error_status,"FIFO Depth for read Test Failed!!!");
endtask 
endmodule
