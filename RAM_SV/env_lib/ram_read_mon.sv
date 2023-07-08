class ram_read_mon;

	//Instantiate virtual interface instance rdmon_if of type ram_if with RD_MON modport
	virtual ram_if.RD_MON rdmon_if;

	//Declare two handles 'data2rm','data2sb' of class type ram_trans
	ram_trans data2rm,data2sb;

	//Declare two mailboxes 'mon2rm' and 'mon2sb' parameterized with ram_trans
	mailbox #(ram_trans) mon2rm;
	mailbox #(ram_trans) mon2sb;
	
//In constructor
		//Pass the following properties as the input arguments 
	
		//pass the virtual interface and the two mailboxes as arguments
	
		//make the connections and allocate memory for 'data2rm' 

	function new(virtual ram_if.RD_MON rdmon_if,
				mailbox #(ram_trans) mon2rm,
				mailbox #(ram_trans) mon2sb);
		this.rdmon_if=rdmon_if;
		this.mon2rm=mon2rm;
		this.mon2sb=mon2sb;
		this.data2rm=new;
	endfunction: new


	task monitor();
		@(rdmon_if.rd_mon_cb);
		wait (rdmon_if.rd_mon_cb.read==1);
        @(rdmon_if.rd_mon_cb);
		begin
			data2rm.read = rdmon_if.rd_mon_cb.read;
			data2rm.rd_address =  rdmon_if.rd_mon_cb.rd_address;
			data2rm.data_out= rdmon_if.rd_mon_cb.data_out;
			//call the display of the ram_trans to display the monitor data
			data2rm.display("DATA FROM READ MONITOR");
		
		end
	endtask
	
	
	//In start task
			
	task start();
	//within fork-join_none

	//In forever loop
		fork
			forever
				begin
	//Call the monitor task
	//Understand the provided monitor task. 
	//Monitor task samples the interface signals 
	//according to the protocol and convert to transaction items 
					monitor(); 
 	//shallow copy data2rm to data2sb;
					data2sb= new data2rm;
	//Put the transaction item into two mailboxes mon2rm and mon2sb
					mon2rm.put(data2rm);
					mon2sb.put(data2sb);
				end
		join_none
	endtask: start

endclass:ram_read_mon
