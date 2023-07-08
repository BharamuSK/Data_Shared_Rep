/************************************************************************
  
Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
  
www.maven-silicon.com 
  
All Rights Reserved. 
This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd. 
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.
  
Filename:       ram_soc.sv
  
Author Name:    Putta Satish

Support e-mail: For any queries, reach out to us on "techsupport_vm@maven-silicon.com" 

Version:	1.0

************************************************************************/
//RAM - SoC
module ram_soc (ram_if.DUV_MP mif0,
                ram_if.DUV_MP mif1,
                ram_if.DUV_MP mif2,
                ram_if.DUV_MP mif3);

  ram_chip MB1 (.mif(mif0));
  ram_chip MB2 (.mif(mif1));
  ram_chip MB3 (.mif(mif2));
  ram_chip MB4 (.mif(mif3));

endmodule
