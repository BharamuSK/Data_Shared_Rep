
class ram_write_bfm;
	// Instantiate virtual interface instance wr_if of type ram_if with WR_BFM modport

	virtual ram_if.WR_BFM wr_if;

	// Declare a handle for ram_trans as 'data2duv'
	
	ram_trans data2duv;

	// Declare a mailbox 'gen2wr' parameterized with ram_trans		
	mailbox #(ram_trans) gen2wr;	

	// In constructor 
	// Pass the following as the input arguments 
	// virtual interface
	// mailbox handle 'gen2wr' parameterized by ram_trans    
    // Make connections
	// For example this.gen2wr=gen2wr
	function new(virtual ram_if.WR_BFM wr_if,
				mailbox #(ram_trans) gen2wr);
		this.wr_if=wr_if;
		this.gen2wr=gen2wr;
	endfunction: new

	virtual task drive();
		@(wr_if.wr_drv_cb);
		wr_if.wr_drv_cb.data_in<=data2duv.data;
		wr_if.wr_drv_cb.wr_address<=data2duv.wr_address;
		wr_if.wr_drv_cb.write<=data2duv.write;
		        
	// Wait for two clock cycles after applying all the inputs
	// if write is high, atleast one clock cycle will be required to write the data
		 repeat(2)
			@(wr_if.wr_drv_cb);

	 // Disable the write signal
		wr_if.wr_drv_cb.write<='0;
			
	endtask : drive
	// In virtual task start
		
	virtual task start();
	// Within fork join_none 
		fork
			forever
				begin
	// Within forever , inside begin end			
	// get the data from mailbox 'gen2wr'
	// call drive task
					gen2wr.get(data2duv);
					drive();
				end
		join_none
	endtask: start

endclass: ram_write_bfm
