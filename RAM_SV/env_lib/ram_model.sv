	// In class ram_model
class ram_model;
	//Declare 2 handles 'mon_data1' and 'mon_data2' for ram_trans
	//( to store the data from the read and write monitor)
	
	ram_trans mon_data1;
	ram_trans mon_data2;

  //Declare an associative array of 64 bits(logic type) and indexed int type
	
	logic [63:0] ref_data[int];

  //Declare 3 mailboxes 'wr2rm','rd2rm' and 'rm2sb' parameterized by ram_trans
	
	mailbox #(ram_trans) wr2rm;
	mailbox #(ram_trans) rd2rm;

	mailbox #(ram_trans) rm2sb;

	//Declare a handle 'rm_data' for ram_trans

    ram_trans rm_data;

	//In constructor
    //Pass mailboxes as the arguments
    //connect the mailboxes
 
	function new(mailbox #(ram_trans) wr2rm,
				mailbox #(ram_trans) rd2rm,
				mailbox #(ram_trans) rm2sb);
		this.wr2rm = wr2rm;
		this.rd2rm=rd2rm;
		this.rm2sb=rm2sb;
	endfunction: new
   
  //Understand and include the tasks dual_mem_fun_read and dual_mem_fun_write
	task dual_mem_fun_write(ram_trans mon_data1);
		begin
			if(mon_data1.write)
			mem_write(mon_data1);
		end
	endtask

	task dual_mem_fun_read(ram_trans mon_data2);
		begin
			if(mon_data2.read)
			mem_read(mon_data2);
		end
	endtask

	task mem_write(ram_trans mon_data1);
		ref_data[mon_data1.wr_address]= mon_data1.data;
	endtask:mem_write


	task mem_read(inout ram_trans mon_data2);
		if(ref_data.exists(mon_data2.rd_address))	
		mon_data2.data_out = ref_data[mon_data2.rd_address];
    
	endtask: mem_read
   //In start task
      
	virtual task start();
		//in fork join_none
		fork
			begin
				fork
					begin
						forever 
							begin
								//get the data from wr2rm mailbox to mon_data1
								wr2rm.get(mon_data1);
								//Call dual_mem_fun_write task and pass the data 'mon_data1' as an argument
								dual_mem_fun_write(mon_data1);
                            end
					end

					begin
						forever
							begin
		//get the data from rd2rm mailbox to mon_data2
								rd2rm.get(mon_data2);
		//Call dual_mem_fun_read task and pass the data 'mon_data2' as an argument
								dual_mem_fun_read(mon_data2);
		//put 'mon_data' into rm2sb mailbox
								rm2sb.put(mon_data2);
                            end
					end
				join
			end
		join_none
	endtask: start

endclass:ram_model
