//import uvm_pkg::*;      //uvm libraray files 
//`include "uvm_macros.svh"//uvm librarty files `  they run during compilation time

module apb_tb;
  
  
   bit PCLK;
   bit PRESETn;

   //Clock Generation
   always #5 PCLK = ~PCLK;


   //Reset gen
   initial
   begin
      PRESETn=1'b0;
      PCLK=1'b0;
      #5;
      PRESETn=1'b1;
   end

   //code for Interface
//   apb_if vif(PCLK,PRESETn);
  
//   apb_ram dut (.presetn(vif.presetn), .pclk(vif.pclk), .psel(vif.psel), .penable(vif.penable), .pwrite(vif.pwrite), .paddr(vif.paddr), .pwdata(vif.pwdata), .prdata(vif.prdata), .pready(vif.pready), .pslverr(vif.pslverr));
   
//   initial begin
//     uvm_config_db#(virtual apb_if)::set(null, "*", "vif", vif);
//     run_test("test");
//    end

   


  
  // initial begin
    // $dumpfile("dump.vcd");
    // $dumpvars//end

//initial
//begin
	//run_test();
//end

  initial 
  begin 
      #2000 $finish;
  end 

 
endmodule
 