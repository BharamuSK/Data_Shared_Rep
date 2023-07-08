/************************************************************************
  
Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
  
www.maven-silicon.com 
  
All Rights Reserved. 
This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd. 
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.
  
Filename:       ram_chip.sv
  
Author Name:    Putta Satish

Support e-mail: For any queries, reach out to us on "techsupport_vm@maven-silicon.com" 

Version:	1.0

************************************************************************/

//RAM - Chip
module ram_chip (ram_if.DUV_MP mif);

  ram_4096 RTL  (.clk(mif.clk),
                 .data_in(mif.data_in),
                 .rd_address(mif.rd_address),
                 .wr_address(mif.wr_address),
                 .read(mif.read),
                 .write(mif.write),
                 .data_out(mif.data_out)) ;
endmodule
