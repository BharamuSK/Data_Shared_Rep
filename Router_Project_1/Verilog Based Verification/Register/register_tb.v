module register_tb();

reg clk;

reg rst;

reg pkt_valid;

reg [7:0]din;

reg fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg;


wire error,parity_done,low_pkt_valid;

wire [7:0]dout;

register dut(clk,rst,pkt_valid,din,fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg,error,parity_done,low_pkt_valid,dout);

//Task CLK
initial
begin
    clk=1'b0;
    forever 
    begin
        #5 clk =~clk;
    end
end


//Task RST
task reset;
begin
    @(negedge clk)
    rst = 1'b0;
    @(negedge clk)
    rst = 1'b1;
end
endtask


// Task Init;
task init;
begin
    din =0;
    {rst,pkt_valid,fifo_full,rst_int_reg,detect_add,laf_state,ld_state,lfd_state,full_state}=9'b0;
end
endtask

task fifo_full_state_byte();
begin
    fifo_full =1'b1;
    ld_state=1;
    laf_state=1'b1;
end
endtask

task header_byte_reader();
begin
    pkt_valid=1'b1;
    detect_add=1'b1;
    lfd_state=1'b1;
end
endtask

task dout_reader();
begin
    // din = 5;
    ld_state=1;
    fifo_full =1'b0;
end
endtask


initial
begin
    init;
    reset;
    /*
    #10;
    din = 5;
    dout_reader;
    #10;
    din=9;
    #10;
    fifo_full_state_byte;
    din=10;
    #10;
    header_byte_reader;
    din = 11;
    #10;
    din = 12;
    #10;
    reset;
    
    
    ld_state=1;
    fifo_full =1'b1;
    #10;
    din=9;
    ld_state=1'b0;
    fifo_full=1'b0;
    laf_state=1'b1;
    #10;
     */
    fifo_full =1'b0;
    full_state =1'b0;
    #10 pkt_valid = 1'b1;

    din = 5;

    detect_add = 1'b1;

    #10 detect_add = 1'b0;
    
    lfd_state = 1'b1;

    #10 lfd_state = 1'b0;   

    din=7;
    ld_state=1'b1;   

    #10 din=8;    
    #10 din=1;  

    #10 ld_state=1'b0;
    full_state=1'b1;

    din=2;

    #10 fifo_full =1'b0;
    full_state =1'b0;
    laf_state = 1'b1;
    #10 laf_state = 1'b0;
    pkt_valid =1'b0;
    din=3;
    #10 rst_int_reg=1'b1;
    $finish;



end


initial 
begin
    $monitor ("time=%t, clock = %b, reset = %b, detect_add=%b, data_in =%d, LAF=%b, LD=%b, Fifo Full=%b, LFD=%b, laf=%b, pkt_valid=%b, full_state=%b, rst_int_re=%b, parity_done=%b, low_pkt_valid=%b, error=%b, Dout=%d",$time,clk,rst,detect_add,din,laf_state,ld_state,fifo_full,lfd_state,laf_state,pkt_valid,full_state,rst_int_reg,parity_done,low_pkt_valid,error,dout); 
end
/*
initial
begin
    #200 $finish();
end
*/
endmodule