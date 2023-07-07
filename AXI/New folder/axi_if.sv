interface axi_if;

    logic rst;
    logic clk;


//-----------write_trxn------------//
//-----------write_address_signals--//    
    logic awvalid;//AWVALID;
    logic awready;//AWREADY;

    logic [3:0] awid;//AWID;
    logic [3:0] awlen;//AWLEN;

    logic [31:0] awaddr;//AWADDR;
    logic [2:0] awsize;//AWSIZE;
        
    logic [1:0] awburst;//AWBURST;
     
    // logic [1:0] awlock//AWLOCK;
    // logic [3:0] AWCACHE;
    // logic [2:0] AWPROT;

//-----------write_data_signals--// 
    logic wvalid;
    logic wready; 
    logic wlast;  

    logic [3:0] wid;    // This must match the WID with AWID for Write Txn
    logic [3:0] wstrb;  //This signal indicates which byte lanes to update in memory// WSTRB[n]=WDATA[(8 × n) + 7:(8 × n)];
    logic [31:0] wdata; // This can be wide up to 1024 bits

//-----------write_response_signals--// 
    logic bvalid;
    logic bready;

    logic [3:0] bid;   //Response ID bid.The identification tag of the write response. The BID == AWID
    logic [1:0] bresp; // This signal indicates the status of the write transaction. The allowable
                        // responses are OKAY(0b00), EXOKAY(0b01), SLVERR(0b10), and DECERR(0b11)


    
endinterface