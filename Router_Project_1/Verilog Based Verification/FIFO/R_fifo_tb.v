module R_fifo_tb();

reg clk,w_en,r_en,lfd_state;

reg rst,soft_rst;

reg [7:0]din;

wire [7:0]dout;
wire  full,empty;

integer i;
integer k;


R_fifo DUT(din,clk,rst,soft_rst,w_en,r_en,lfd_state,dout,full,empty);


task init();
begin
    rst=1'b0;
    soft_rst=1'b0;
    clk=1'b0;
    w_en=1'b0;
    r_en=1'b0;
end
endtask

always #10 clk=~clk;

task reset();
begin
    @(negedge clk);
    rst=1'b0;    
    @(negedge clk);
    rst=1'b1;
end
endtask

task softreset();
begin    
    @(negedge clk);
    soft_rst=1'b1;    
    @(negedge clk);
    soft_rst=1'b0;    
end
endtask

task write();
reg [7:0] payload_data,header,parity;
reg [5:0] payload_length;
reg [1:0] addr;
begin
    @(negedge clk);
    payload_length = 6'd14;
    addr = 2'b01;
    header = {payload_length,addr};
    din = header;
    lfd_state =1'b1;
    w_en =1'b1;
    $display("Fifo Full=%b",full);
    $display("Fifo Empty=%b",empty);

    for(k=0;k<payload_length;k=k+1)
    begin
        @(negedge clk);
        lfd_state = 1'b0;
        payload_data ={$random} % 256;
        din=payload_data;
    end

    @(negedge clk)
    parity = {$random}% 256;
    din= parity;
    $display("Fifo Full=%b",full);
    $display("Fifo Empty=%b",empty);
end
endtask


task read();
begin
    @(negedge clk);
    w_en=1'b0;
    r_en=1'b1;
end
endtask


initial 
begin
    init;  
    #50;
    reset;
    softreset;

    write;
    $display("Fifo Full=%b",full);
    for(i=0 ; i<17 ; i=i+1)
    begin
        read;        
    end  

    #50;
    r_en=1'b0;

end

initial
begin
    $monitor("time=%t, rst=%b, soft_rst=%b, clk=%b, w_en=%b, r_en=%b, din=%b, lfd_state=%b, dout=%b, full=%b, empty=%b",$time,rst,soft_rst,clk,w_en,r_en,din,lfd_state,dout,full,empty);
end

initial
begin
    #1000 $finish();
end

endmodule