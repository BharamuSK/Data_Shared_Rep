interface apb_intf(input bit PCLK);

    logic PRESETn;
    logic [31:0] PADDR;
    logic PSELx;
    logic PENABLE;
    logic PWRITE;

    logic [31:0]PWDATA;
    logic PREADY;

    logic [31:0]PRDATA;
    logic PSLVERR;

endinterface

    rand bit[31:0] PADDR;
         bit PSELx;
         bit PENABLE;
    rand bit PWRITE;
    
    rand bit[31:0] PWDATA;
         bit PREADY;

         bit [31:0]PRDATA;

         bit PSLVERR;  //Tied to if We are verifying APB Memory only 