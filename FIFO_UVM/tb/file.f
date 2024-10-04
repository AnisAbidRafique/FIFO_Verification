// 64 bit option for AWS labs
-64

-uvmhome /home/cc/mnt/XCELIUM2309/tools/methodology/UVM/CDNS-1.1d

-timescale 1ns/1ns
// include directories
//*** add incdir include directories here
-incdir ../sv
../sv/fifo.sv

../sv/fifo_pkg.sv
top.sv
../sv/fifo_interface.sv

// compile files
//*** add compile files here

-access +rwc


+UVM_TESTNAME=fifo_exhaustive_test
+UVM_VERBOSITY=UVM_LOW
