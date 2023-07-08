/************************************************************************
  
Copyright 2019 - Maven Silicon Softech Pvt Ltd.  
  
www.maven-silicon.com 
  
All Rights Reserved. 
This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd. 
It is not to be shared with or used by any third parties who have not enrolled for our paid 
training courses or received any written authorization from Maven Silicon.
  
Filename:       ram_virtual_seqs.sv
  
Author Name:    Putta Satish

Support e-mail: For any queries, reach out to us on "techsupport_vm@maven-silicon.com" 

Version:	1.0

************************************************************************/
//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------



//------------------------------------------------------------------------------
//
// SEQUENCE: Base RAM virtual sequence - base virtual sequence with objections from which 
// all virtual sequences can be derived
//
//------------------------------------------------------------------------------

  // Extend ram_vbase_seq from uvm_sequence parameterized by uvm_sequence_item;

class ram_vbase_seq extends uvm_sequence #(uvm_sequence_item);

	
  // Factory registration
	`uvm_object_utils(ram_vbase_seq)  
  // LAB : Declare dynamic array of handles for ram_wr_sequencer and ram_rd_sequencer as wr_seqrh[] & rd_seqrh[]
        
  // Declare handle for virtual sequencer
        ram_virtual_sequencer vsqrh;
  // Declare Handles for all the sequences
	ram_single_addr_wr_xtns single_wxtns;
	ram_single_addr_rd_xtns single_rxtns;

	ram_ten_wr_xtns ten_wxtns;
	ram_ten_rd_xtns ten_rxtns;

	ram_even_wr_xtns even_wxtns;
	ram_even_rd_xtns even_rxtns;

	ram_odd_wr_xtns odd_wxtns;
	ram_odd_rd_xtns odd_rxtns;

  // LAB :  Declare handle for ram_env_config
	


//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
 	extern function new(string name = "ram_vbase_seq");
	extern task body();
	endclass : ram_vbase_seq  
//-----------------  constructor new method  -------------------//

// Add constructor 
	function ram_vbase_seq::new(string name ="ram_vbase_seq");
		super.new(name);
	endfunction
//-----------------  task body() method  -------------------//


task ram_vbase_seq::body();
// get the config object ram_env_config from database using uvm_config_db 
	  
// initialize the dynamic arrays for write & read sequencers to m_cfg.no_of_duts
 
  

  assert($cast(vsqrh,m_sequencer)) else begin
    `uvm_error("BODY", "Error in $cast of virtual sequencer")
  end
// Assign ram_wr_sequencer & ram_rd_sequencer handles to virtual sequencer's 
// ram_wr_sequencer & ram_rd_sequencer handles
// Hint : use foreach loop
 
endtask: body

   

//------------------------------------------------------------------------------
//                 single address sequence

//------------------------------------------------------------------------------
// Extend ram_single_vseq from ram_vbase_seq
	class ram_single_vseq extends ram_vbase_seq;

     // Define Constructor new() function
	`uvm_object_utils(ram_single_vseq)

//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
 	extern function new(string name = "ram_single_vseq");
	extern task body();
	endclass : ram_single_vseq  
//-----------------  constructor new method  -------------------//

// Add constructor 
	function ram_single_vseq::new(string name ="ram_single_vseq");
		super.new(name);
	endfunction
//-----------------  task body() method  -------------------//

		task ram_single_vseq::body();
                 super.body();
                 // LAB : create the instances for ram_single_addr_wr_xtns & ram_single_addr_rd_xtns
                  
                    if(m_cfg.has_wagent) begin
                   for (int i=0 ; i < m_cfg.no_of_duts; i++)
                  // LAB : Start the write sequence on all the write sequencers 
	              
                   end

                   if(m_cfg.has_ragent) begin
                   for (int i=0 ; i < m_cfg.no_of_duts; i++)
		  // LAB : Start the read sequence on all the read sequencers  
						
                    end 

       endtask

//------------------------------------------------------------------------------
//                 ten address sequence

//------------------------------------------------------------------------------
// Extend ram_ten_vseq from uvm_sequence
    	 class ram_ten_vseq extends ram_vbase_seq;

     // Define Constructor new() function
	`uvm_object_utils(ram_ten_vseq)

//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
 	extern function new(string name = "ram_ten_vseq");
	extern task body();
	endclass : ram_ten_vseq  
//-----------------  constructor new method  -------------------//

// Add constructor 
	function ram_ten_vseq::new(string name ="ram_ten_vseq");
		super.new(name);
	endfunction
//-----------------  task body() method  -------------------//

	task ram_ten_vseq::body();
                 super.body();
                  // LAB :  create the instances for ram_ten_wr_xtns & ram_ten_rd_xtns
		    

                   if(m_cfg.has_wagent) begin
                   for (int i=0 ; i < m_cfg.no_of_duts; i++) 
		  // LAB :  Start the write sequence on all the write sequencers
	               
                   end

                   if(m_cfg.has_ragent) begin
                   for (int i=0 ; i < m_cfg.no_of_duts; i++) 
		  // LAB :  Start the read sequence on all the read sequencers
	               
                    end 

       endtask



//------------------------------------------------------------------------------
//                 even sequence

//------------------------------------------------------------------------------
// Extend ram_even_vseq from ram_vbase_seq
    	 class ram_even_vseq extends ram_vbase_seq;

     // Factory Registration
	`uvm_object_utils(ram_even_vseq)

//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
 	extern function new(string name = "ram_even_vseq");
	extern task body();
	endclass : ram_even_vseq  
//-----------------  constructor new method  -------------------//

// Add constructor 
	function ram_even_vseq::new(string name ="ram_even_vseq");
		super.new(name);
	endfunction
//-----------------  task body() method  -------------------//



	task ram_even_vseq::body();
                 super.body();
		// LAB :  create the instances for ram_even_wr_xtns & ram_even_rd_xtns
                    

                   if(m_cfg.has_wagent) begin
                   for (int i=0 ; i < m_cfg.no_of_duts; i++) 
		// LAB :  Start the write sequence on all the write sequencers
	               
                   end

                   if(m_cfg.has_ragent) begin
                   for (int i=0 ; i < m_cfg.no_of_duts; i++)
		// LAB :  Start the read sequence on all the read sequencers
	               
                    end 

       endtask


//------------------------------------------------------------------------------
//                 odd sequence

//------------------------------------------------------------------------------
// Extend ram_odd_vseq from ram_vbase_seq
    	 class ram_odd_vseq extends ram_vbase_seq;

     // Factory Registration
	`uvm_object_utils(ram_odd_vseq)

//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
 	extern function new(string name = "ram_odd_vseq");
	extern task body();
	endclass : ram_odd_vseq  
//-----------------  constructor new method  -------------------//

// Add constructor 
	function ram_odd_vseq::new(string name ="ram_odd_vseq");
		super.new(name);
	endfunction
//-----------------  task body() method  -------------------//


		task ram_odd_vseq::body();
                 super.body();
		// LAB :  create the instances for ram_odd_wr_xtns & ram_odd_rd_xtns
                   

                   if(m_cfg.has_wagent) begin
                   for (int i=0 ; i < m_cfg.no_of_duts; i++) 
		// LAB :  Start the write sequence on all the write sequencers
	              
                   end

                   if(m_cfg.has_ragent) begin
                   for (int i=0 ; i < m_cfg.no_of_duts; i++) 
		// LAB :  Start the read sequence on all the read sequencers
	               
                    end 

       endtask

