/********************************************************************************************

Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
www.maven-silicon.com

All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.

Filename		:	ram_pkg.sv   

Description		:	Package for dual port ram_testbench

Author Name		:	Putta Satish

Support e-mail  : 	For any queries, reach out to us on "techsupport_vm@maven-silicon.com" 

Version			:	1.0

*********************************************************************************************/
package ram_pkg;

   int number_of_transactions=1;

	`include "ram_trans.sv"
	`include "ram_gen.sv"
	`include "ram_write_bfm.sv"
	`include "ram_read_bfm.sv"
	`include "ram_write_mon.sv"
	`include "ram_read_mon.sv"
	`include "ram_model.sv"
	`include "ram_sb.sv"
	`include "ram_env.sv"


endpackage
