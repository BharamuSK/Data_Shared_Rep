//AHB INTERFACE FOR BRIDGE

interface ahb_if(input bit clk);

	//AHB as master signals
	
	logic Hresetn, Hwrite;
	logic [2:0] Hsize;  //Transfer size
	logic [1:0] Htrans; //Transfer type
	logic [2:0] Hburst; //Transfer burst type
	logic [31:0]Hwdata;	//Write data bus
	
	//AHB as Slave signals
	
	logic Hreadyin;		//Indicator
	logic Hreadyout;	//Indicator
	logic [1:0] Hresp;	//Transfer response
	logic [31:0] Haddr;	//Transfer address
	logic [31:0] Hrdata;//Read data bus
	
	//AHB Driver Clocking block
	
		clocking ahb_drv_cb@(posedge clk);
			default input #1 output #1;
					
							output Hwrite;
							output Hreadyin;
							output Haddr;
							output Htrans;
							output Hburst;
							output Hresetn;
							output Hsize;
							input  Hreadyout;
					
		endclocking
		
	//AHB monitor clocking block
	
		clocking ahb_mon_cb@(posedge clk);
			default input #1 output #1;
					
					input Hwrite;
					input Hreadyin;
					input Haddr;
					input Htrans;
					input Hburst;
					input Hresetn;
					input Hsize;
					input Hreadyout;
					
		endclocking
		
		
	// modport decleration
	
		modport AHB_DRV_MP (clocking ahb_drv_cb);
		modport AHB_MON_MP (clocking ahb_mon_cb);
		
endinterface : ahb_if