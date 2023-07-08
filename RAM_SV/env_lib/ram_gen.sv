class ram_gen;

	//Declare gen_trans handle of class type ram_trans which has to be randomized
	ram_trans gen_trans;

	//Declare data2send handle of class type ram_trans which has to be put into the mailboxes
    ram_trans data2send;

	//Declare 2 mailboxes parameterized by ram_trans
	mailbox #(ram_trans) gen2rd;
	mailbox #(ram_trans) gen2wr;
 
	//In constructor
	//Add  mailbox argument parameterized by transaction class and make the assignment to the mailbox
	//And Create the object for the handle to be randomized
	function new(mailbox #(ram_trans) gen2rd,
				mailbox #(ram_trans) gen2wr);
		this.gen_trans=new;
		this.gen2rd=gen2rd;
		this.gen2wr=gen2wr;
	endfunction: new

	// In virtual task start

	virtual task start();
	//Inside fork join_none 
		fork
			begin
	//Generate random transactions equal to number_of_transactions(defined in package) 
				for(int i=0; i<number_of_transactions;i++)
					begin			
	//Randomize using transaction handle using 'if' or 'assert'
	//If randomization fails, display message "DATA NOT RANDOMIZED" and stop the simulation
						assert(gen_trans.randomize());
    //Copy gen_trans to data2send
                        data2send=new gen_trans;
	//Put the handle into both the mailboxes
						gen2rd.put(data2send);
						gen2wr.put(data2send);
					end
			end
		join_none
	endtask: start

endclass: ram_gen
	
	   
 


