interface apb_if (input bit clock);

    logic Penable, Pwrite; //APB strobe, APB transfer direction - master

    //APB read data bus - slave
    logic [31:0] Prdata;

    //APB write data bus - master
    logic [31:0] Pwdata;

    //APB addr bus - master
    logic [31:0] Paddr;

    //APB select - master
    logic [3:0] Pselx;

    //APB Driver
    clocking apb_drv_cb @(posedge clock);
            default input #1 output #1;
            //Read data.
            // The PRDATA read data bus is driven by the selected Completer during read cycles when
            // PWRITE is LOW.
            // PRDATA can be 8 bits, 16 bits, or 32 bits wide.
            output Prdata;  // Perite=0 then the read data bus will selected during read cycle

            // PENABLE indicates the second and subsequent
            //         cycles of an APB transfer
            input Penable;  // Its used to indicate the 2nd cycle of Bus

            //PWRITE indicates an APB write access when HIGH
            //                    APB read access when LOW.
            input Pwrite;   // High Write acess else low read acess // APB Transfer direction
    
            input Pselx;    //doubt Its use to select the each bus slave.
            // The Requester generates a PSELx signal for each
            // Completer. PSELx indicates that the Complete selected and that a data transfer is required
    endclocking
 
    //APB monitor
    clocking apb_mon_cb @(posedge clock);
            default input #1 output #1;

            input Prdata;
            input Penable;
            input Pwrite;
            input Pselx;
            input Paddr;
            input Pwdata;

            //If Pen =1 then 

            // Store the data in XTN file i.e sel,Pwrite,Paddr. 
            //after that 
            // If write=1 then its a Write access then Store the data xtn.Pwdata=vif.apb_mon_cb.Pwdata
            // If write=0 then its a Read access then Store the data  xtn.Prdata= vif.apb_mon_cb.Prdata

    endclocking
//DRIVER and monitor modport:
modport APB_DRV_MP (clocking apb_drv_cb);
modport APB_MON_MP (clocking apb_mon_cb);

endinterface: apb_if
