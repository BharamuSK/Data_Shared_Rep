module synchronizer_tb();

reg clk,rst;

reg [1:0] din;   //Used to latch the Address  When the Address detects Decode state to LFD ()
//Load First data of The FIFO Block

reg wr_en_reg,det_addr;

reg f_0,f_1,f_2;     //From FIFO 

reg e_0,e_1,e_2;     //From FIFO  and Its The Inversion Of valid out Signal

reg re_0,re_1,re_2;  // From Destination Address

wire [2:0]wr_en;     // From Output OF FSM  It will high Whenever the Write the Operation is High 

wire fifo_full;      //Input to The FSM 

wire valid_out_0,valid_out_1,valid_out_2;

wire soft_rst0,soft_rst1,soft_rst2;


synchronizer DUT(clk,rst,wr_en_reg,wr_en,din,det_addr,f_0,f_1,f_2,e_0,e_1,e_2,re_0,re_1,re_2,fifo_full,valid_out_0,valid_out_1,valid_out_2,soft_rst0,soft_rst1,soft_rst2);

// clk
initial 
begin
    clk=1'b0;
    forever 
    begin
        #5 clk = ~clk;    
    end    
end

//task reset

task reset;
begin
    rst=1'b0;
    #10;
    rst=1'b1;
    $display("Reset Sucess");
end
endtask

//Task Init  (Fifo full 1 and 2 and 0 ==0)



//task input 2 bit input
task d_in(input [1:0]m);
begin
    @(negedge clk)
    begin
    wr_en_reg=1'b1;
    det_addr=1'b1;
    din = m;
    end
end
endtask





initial
begin
    reset;

    //write enable register 

    //data input
    wr_en_reg=1'b1;
    det_addr=1'b1;
    #10;
    d_in(2'b00);         // Output = 001
  
    #10;
    d_in(2'b01);         //Output = 010
  
    #10;
    d_in(2'b10);
    
    //Fifo full 
    // 01
    #10;
    d_in(2'b10);
    f_1=1'b0;
    f_0=1'b0;
    f_2=1'b1;
    #10;
    
    d_in(2'b00);
    f_1=1'b0;
    f_0=1'b1;
    f_2=1'b0;
    #10;
    $display("full0=%b-----full 1=%b------full 2=%b,fifofull=%b\n",f_0,f_1,f_2,fifo_full);
    
 
    //valid out
    //Jst empty0=1, then valid = 0 then 
    #10;
    e_0=1'b0;
    e_1=1'b1;
    e_2=1'b1;

    #10;
   $display("Valid Out 0=%b-----Valid Out 1=%b------Valid Out 2=%b\n",valid_out_0,valid_out_1,valid_out_2);

    e_0=1'b1;
    e_1=1'b0;
    e_2=1'b1;

    #10;
  //  $display("Valid Out 0=%b-----Valid Out 1=%b------Valid Out 2=%b\n",valid_out_0,valid_out_1,valid_out_2);

    
    e_0=1'b1;
    e_1=1'b1;
    e_2=1'b0;
  //  $display("Valid Out 0=%b-----Valid Out 1=%b------Valid Out 2=%b\n",valid_out_0,valid_out_1,valid_out_2);



    //soft reset
    // Give delay 30 cycles
    // make valid_out_1 = 1 and re = 0 and empty =0;
    #10;
   // $display("Valid Out 0=%b-----Valid Out 1=%b------Valid Out 2=%b\n",valid_out_0,valid_out_1,valid_out_2);
    e_0=1'b0;
    e_1=1'b1;
    e_2=1'b1;

    re_0=1'b0;


    #300;




end 


initial
begin
    $monitor("wr_en_reg=%b------det_add=%b-----din=%b----wr_en=%b-----fifo_full=%b---valid_0=%b------valid_1=%b-------valid_2=%b",wr_en_reg,det_addr,din,wr_en,fifo_full,valid_out_0,valid_out_1,valid_out_2);
    // $monitor("re_0=%b------valid_0=%b-----empty=%b----Softrst 0= %b",re_0,valid_out_0,e_0,soft_rst0);
end



initial
begin
    #1000 $finish();
end





endmodule