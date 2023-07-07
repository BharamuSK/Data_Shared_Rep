module fsm_tb();

reg clk,rst,pkt_valid;  // reg from Source network 

reg [1:0]din;           

// From Synchronizer

reg fifo_full;
 

// From FIFO
reg fifo_empty_0,fifo_empty_1,fifo_empty_2;

//Synchronizer
reg soft_rst_0,soft_rst_1,soft_rst_2;


//From Register Block
reg parity_done;       

reg low_pkt_valid;   


wire wr_en_reg;

wire detect_add,ld_state,laf_state,lfd_state,full_state,rst_in_reg;

wire busy;

parameter DECODE_ADDRESS =3'b000,
          LOAD_FIRST_DATA =3'b001,
          LOAD_DATA =3'b010,
          FIFO_FULL_STATE =3'b011,
          LOAD_AFTER_FULL =3'b100,
          LOAD_PARITY =3'b101,
          CHECK_PARITY_ERROR=3'b110,
          WAIT_TILL_EMPTY =3'b111;


fsm DUT(din,clk,rst,pkt_valid,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,soft_rst_0,soft_rst_1,soft_rst_2,parity_done,low_pkt_valid,wr_en_reg,detect_add,ld_state,laf_state,lfd_state,full_state,rst_in_reg,busy);



initial
begin
    clk=1'b0;
    forever 
    begin
        #5 clk=~clk;
    end
end

task init;
begin
    rst=1'b1;
    din=0;
    fifo_full=1'b1;
    low_pkt_valid=1'b0;
    {soft_rst_0,soft_rst_1,soft_rst_2}=3'b000;
    $display("Init Sucess");
end
endtask

task reset;
begin
    @(negedge clk)
    rst=1'b0;
    @(negedge clk)
    rst=1'b1;
    $display("RST Sucess");
end
endtask

task soft_rst0;
begin
    @(negedge clk)  
    soft_rst_0 = 1'b1;
    @(negedge clk)
    soft_rst_0 =1'b0;
end
endtask

task soft_rst1;
begin
    @(negedge clk)  
    soft_rst_1 = 1'b1;
    @(negedge clk)
    soft_rst_1 =1'b0;
end
endtask

task soft_rst2;
begin
    @(negedge clk)  
    soft_rst_2 = 1'b1;
    @(negedge clk)
    soft_rst_2 =1'b0;
end
endtask

//When payload is Less
task DA_LFD_LD_LP_CPE_DA;
begin
    @(negedge clk)
    begin
    pkt_valid = 1'b1;
    din=2'b00;
    fifo_empty_0=1'b1;
    end
    #20;
    @(negedge clk)
    begin
        pkt_valid =1'b0;
        fifo_full =1'b0;
    end
end
endtask


task DA_LFD_LD_FFS_LAF_LP_CPE_DA;
begin
     @(negedge clk)
     begin
     pkt_valid =1'b1;
     din=2'b00;
     fifo_empty_0=1'b1;
     fifo_full=1'b0;
     end
     #20;
     @(negedge clk)
     begin
     $display("Fifo Full=1\n");
     fifo_full=1'b1;
     end
     @(negedge clk)
     begin
     $display("Fifo Full=0\n");
     fifo_full=1'b0;
     low_pkt_valid=1'b1;
     parity_done =1'b0;
     end

end
endtask


task DA_LFD_LD_FFS_LAF_LD_LP_CPE_DA;
begin
     @(negedge clk)
     begin
     pkt_valid =1'b1;
     din=2'b00;
     fifo_empty_0=1'b1;
     fifo_full=1'b1;
     end
     #40;
     @(negedge clk)
     begin
     $display("Fifo Full=1\n");
     fifo_full=1'b1;
     end
     @(negedge clk)
     begin
     fifo_full=1'b0;
     low_pkt_valid=1'b0;
     parity_done =1'b0;
     end
     #20;
     @(negedge clk)
     begin
     pkt_valid =1'b0;
     end
end
endtask



task DA_LFD_LD_LP_CPE_FFS_LAF_DA;
begin
    //DA_LFD_LD
    @(negedge clk)
    begin
    pkt_valid = 1'b1;
    din=2'b00;
    fifo_empty_0=1'b1;
    end
    #20;
    @(negedge clk)
    begin
    $display("Fifo Full=0\n");
    pkt_valid =1'b0;
    fifo_full =1'b0;
    end
    // repeat(1)
    //CPE to LAF
    #10; 
    @(negedge clk)
    begin
    $display("Fifo Full=1\n");
    fifo_full=1'b1;
    end
    #20;
    @(negedge clk)
    begin
    fifo_full =1'b0;
    parity_done =1'b1;
    end
    /*
    @(negedge clk)
    begin
    parity_done =1'b1;
    end
    */
    // fifo_full =1'b0;
    // parity_done =1'b1;

end
endtask


reg [18*8:0] string_cmd;

always @(DUT.present_state)
begin
    case(DUT.present_state)
            DECODE_ADDRESS : string_cmd="DECODE_ADDRESS";
            LOAD_FIRST_DATA : string_cmd="LOAD_FIRST_DATA";
            LOAD_DATA : string_cmd="LOAD_DATA";
            FIFO_FULL_STATE : string_cmd="FIFO_FULL_STATE";
            LOAD_AFTER_FULL : string_cmd="LOAD_AFTER_FULL";
            LOAD_PARITY : string_cmd="LOAD_PARITY";
            CHECK_PARITY_ERROR : string_cmd="CHECK_PARITY_ERROR";
            WAIT_TILL_EMPTY : string_cmd="WAIT_TILL_EMPTY";
                 
    endcase
end



initial
    begin
        init;
        reset;
        #10;
        
        $display("DA_LFD_LD_LP_CPE_DA");
        DA_LFD_LD_LP_CPE_DA;
        #90;

        reset;
        #10;
        
        $display("DA_LFD_LD_FFS_LAF_LP_CPE_DA");
        DA_LFD_LD_FFS_LAF_LP_CPE_DA;
        #120;

        reset;
        #10;
        
        $display("DA_LFD_LD_FFS_LAF_LD_LP_CPE_DA");
        DA_LFD_LD_FFS_LAF_LD_LP_CPE_DA;
        #180;
        
        reset;
        #10;
        
        $display("DA_LFD_LD_LP_CPE_FFS_LAF_DA");
        DA_LFD_LD_LP_CPE_FFS_LAF_DA;
        
    end



initial
begin
    $monitor("time=%t, clk=%b, rst=%b,state=%s , busy =%b , detect_address=%b, LFD=%b , LD=%b , LAF=%b, fifo_full=%b, write_en=%b, rst_int_reg=%b",$time,clk,rst,string_cmd,busy,detect_add,lfd_state,ld_state,laf_state,full_state,wr_en_reg,rst_in_reg);   
end

initial
begin
    #700 $finish;
end
 
endmodule