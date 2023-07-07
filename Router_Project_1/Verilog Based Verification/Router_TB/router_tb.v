
module router_tb();


reg clock,reset,pkt_valid,read_en_0,read_en_1,read_en_2;

reg [7:0]din;

wire valid_out_0,valid_out_1,valid_out_2,error,busy;


wire [7:0]dout_0,dout_1,dout_2;


router DUT(clock,reset,pkt_valid,read_en_0,read_en_1,read_en_2,din,valid_out_0,valid_out_1,valid_out_2,error,busy,dout_0,dout_1,dout_2);




task init();
begin
clock=1'b0;
reset=1'b0;
din=8'b00000001;
$display("Init Sucess\n");

end
endtask



always #10 clock=~clock;


task rst_dut();
begin
    @(negedge clock);
    reset=1'b0;
    @(negedge clock);
    reset=1'b1;
    $display("Reset Sucess\n");
end
endtask


task packet_14();
reg [7:0] payload_data,header,parity;
reg [5:0] payload_length;
reg [1:0] addr;
integer k;
begin

    @(negedge clock);
    wait (~busy)
    @(negedge clock);
    payload_length=6'd14;
    addr=2'b01;
    header={payload_length,addr};
    parity=8'b0;
    din=header;
    pkt_valid=1'b1;
    parity = parity ^ header;

    @(negedge clock);
    wait(~busy)
    for (k=0 ; k<payload_length ;k=k+1 )
     begin
        @(negedge clock);
        wait(~busy)
        payload_data={$random}%256;
        din=payload_data;
        parity= parity ^ din;   
     end

    @(negedge clock);
    wait(~busy)
    pkt_valid = 1'b0;
    din =parity;
    
end
endtask


task packet_16();
reg [7:0] payload_data,header,parity;
reg [5:0] payload_length;
reg [1:0] addr;
integer k;
begin
    @(negedge clock);
    wait (~busy)
    @(negedge clock);
    payload_length=6'd16;
    addr=2'b01;
    header={payload_length,addr};
    parity=8'b0;
    din=header;  
    pkt_valid=1'b1;
    parity = parity ^ header;
    @(negedge clock);
    wait(~busy)
    for (k=0 ; k<payload_length ;k=k+1 )
     begin
        @(negedge clock);
        wait(~busy)
        payload_data={$random}%256;
        din=payload_data;
        parity= parity ^ din;   
     end
    @(negedge clock);
    wait(~busy)
    pkt_valid = 1'b0;
    din =parity;
end
endtask
/*
task packet_32();
reg [7:0] payload_data,header,parity;
reg [5:0] payload_length;
reg [1:0] addr;
integer k;
begin
    @(negedge clock);
    wait (~busy)
    @(negedge clock);
    payload_length=6'd32;
    addr=2'b01;
    header={payload_length,addr};
    parity=8'b0;
    din=header;  
    pkt_valid=1'b1;
    parity = parity ^ header;
    @(negedge clock);
    wait(~busy)
    for (k=0 ; k<payload_length ;k=k+1 )
     begin
        @(negedge clock);
        wait(~busy)
        payload_data={$random}%256;
        din=payload_data;
        parity= parity ^ din;

     end
    // wait(!valid_out_1)
    @(negedge clock);
    wait(~busy)
    pkt_valid = 1'b0;
    din =parity;
    // $display("Fifo=%b\n",fifo_full);
end
endtask
*/
initial 
begin
    init;
    rst_dut;
    #10;
    packet_16;
    @(negedge clock);
    read_en_1=1'b1;
    wait(!valid_out_1)
    @(negedge clock);
    read_en_1=1'b0;
    #10;
    
    packet_14;
    @(negedge clock);
    read_en_1=1'b1;
    wait(!valid_out_1)
    @(negedge clock);
    read_en_1=1'b0;  
    
    /*
    packet_32;
    @(negedge clock);
    read_en_1=1'b1;
    wait(!valid_out_1)
    @(negedge clock);
    read_en_1=1'b0;  
    */
    $finish;  
end
/*
initial
begin
    $monitor("din[1] =%b-----din[0]=%b----Dout_1=%h-----------re_1=%b------------Vvalid_out_1=%b------",din[1],din[0],dout_1,read_en_1,valid_out_1);
end
*/
/*
initial
begin
    #1000 $finish();
end
*/

endmodule
