class generator#(parameter DEPTH=8, DATA_WIDTH=8);

mailbox #(transaction #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH))) driver;
mailbox #(transaction #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH))) scb;
int count,test_sel;
bit tx_success;

transaction #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH))data; 
// transaction scb; 

function new(mailbox #(transaction #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH))) driver,mailbox #(transaction #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH))) scb,int count = 2,int test_sel = 2);
    this.scb        = scb; 
    this.driver     = driver; 
    this.count      = count;
    this.test_sel   = test_sel;
    data            = new();
    
endfunction

task run();
    $display("INSIDE GENERATOR CLASS [GENERATOR]");
    case (test_sel)
        0 : 
            begin 
                $display("=======================FIFO_RESET===============================");
                reset();
            end
        1 : 
            begin
                $display("===========================================================");
                $display("                  FIFO Full flag Test");
                $display("===========================================================\n"); 
                reset(); //1
                full_flag_test(); // DEPTH
            end
        2 :
            begin
                $display("===========================================================");
                $display("                  FIFO Empty flag Test");
                $display("===========================================================\n"); 
                reset(); //1
                full_flag_test();  //DEPTH
                Empty_flag_test(); //DEPTH
            end
        3 :
            begin
                $display("===========================================================");
                $display("                  FIFO Async reset Test");
                $display("===========================================================\n"); 
                reset_check(); //count * 4
            end
        4 : 
            begin
                $display("===========================================================");
                $display("                  FIFO RAW Test Directed");
                $display("===========================================================\n"); 
                reset(); // 1
                read_after_write_test(); // count * 2
            end
        5 :
            begin
                $display("===========================================================");
                $display("                  FIFO RAW Test Random");
                $display("===========================================================\n");  
                reset(); // 1
                read_after_write_random_test(); // count * 2
            end
        6 :
            begin 
                $display("===========================================================");
                $display("                  FIFO depth Test");
                $display("===========================================================\n"); 
                reset(); // 1
                depth_check(); // 2*DEPTH + 40
            end
        default : $display("Kindly select the valid test. Thanks");
    endcase
        //assert(data.randomize()) else $display("Randomization Failed"); //creating different test cases
        
    tx_success = 1;
    $display("Transaction generation completed");
    // $finish;
    
endtask

task reset();
    data.rst_n = 0;
    driver.put(data.copy());
    scb.put(data.copy());
    // data.display();
endtask


task full_flag_test();

for (int i = 0; i< DEPTH+1; i++)
begin
    data.rst_n = 1;
    data.data_in = 1;
    data.r_en = 0;
    data.w_en =  1;
    data.display();
    driver.put(data.copy());
    scb.put(data.copy());
end
endtask

task Empty_flag_test();
for (int i = 0; i< DEPTH + 1; i++)
begin
    data.rst_n = 1;
    data.r_en = 1;
    data.w_en = 0;
    data.display();
    driver.put(data.copy());
    scb.put(data.copy());
end
endtask

task read_after_write_test();
repeat(count)
    begin
        data.rst_n = 1;
        data.data_in = 5;
        data.r_en = 0;
        data.w_en =  1;
        driver.put(data.copy());
        scb.put(data.copy());
        data.display();
        data.r_en = 1;
        data.w_en = 0;
        driver.put(data.copy());
        scb.put(data.copy());
        data.display();
    end
endtask

task read_after_write_random_test();
repeat(count)
    begin
        data.rst_n = 1;
        assert(data.randomize()) else $display("Randomization Failed"); //creating different test cases
        data.r_en = 0;
        data.w_en =  1;
        driver.put(data.copy());
        scb.put(data.copy());
        data.display();
        data.r_en = 1;
        data.w_en = 0;
        driver.put(data.copy());
        scb.put(data.copy());
        data.display();
    end
endtask

task depth_check();
//write
  for (int i = 0; i< DEPTH + 20; i++)
      begin
        data.rst_n = 1;
        data.data_in = i;
        data.r_en = 0;
        data.w_en =  1;
        driver.put(data.copy());
        scb.put(data.copy());
        data.display();
      end
//read
  for (int i = 0; i< DEPTH + 20; i++)
      begin
        data.rst_n = 1;
        data.r_en = 1;
        data.w_en = 0;
        driver.put(data.copy());
        scb.put(data.copy());
        data.display();
      end
endtask 
    
task reset_check();
repeat(count)
    begin
        data.rst_n = 1;
        driver.put(data.copy());
        scb.put(data.copy());
        data.display();

        data.rst_n      = 0;
        driver.put(data.copy());
        scb.put(data.copy());
        data.display();

        data.data_in    = 15;
        data.r_en       = 0;
        data.w_en       =  1;
        driver.put(data.copy());
        scb.put(data.copy());
        data.display();

        data.rst_n = 0;
        data.r_en = 1;
        data.w_en = 0;
        driver.put(data.copy());
        scb.put(data.copy());
        data.display();

        data.rst_n = 1;
        driver.put(data.copy());
        scb.put(data.copy());
        data.display();
    end
endtask

endclass