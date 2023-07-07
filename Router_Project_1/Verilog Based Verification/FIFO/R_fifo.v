// module fifo(clk,rst,w_en,soft_rst,r_en,din,lfd_state,empty,dout,full);

module R_fifo(din,clk,rst,soft_rst,w_en,r_en,lfd_state,dout,full,empty);


parameter depth=16,width=8,address_bus=5;

input [width-1:0] din;
input w_en,r_en,clk,rst,soft_rst,lfd_state;
reg [address_bus-1:0] rd_ptr,wr_ptr;
reg [6:0] fifo_counter;
output reg [width-1:0] dout;
output full,empty;

integer i;
reg lfd_temp;
reg [width:0] memory [depth-1:0];

always @ (posedge clk)
begin
    if((!rst) || (soft_rst))
       lfd_temp <= 1'b0;
    else 
       lfd_temp <= lfd_state;
end

always @ (posedge clk)
begin
    if((!rst) || (soft_rst))
    begin
        wr_ptr <= 5'b0;
        rd_ptr <= 5'b0;
    end

    else
    begin
        if (!full && w_en)
             wr_ptr <= wr_ptr + 1'b1;
        else 
             wr_ptr <= wr_ptr;

        if (!empty && r_en)
             rd_ptr <= rd_ptr+1'b1;
        else
             rd_ptr <= rd_ptr;
    end
end

always @ (posedge clk)
begin
    if ((!rst) || (soft_rst))
         fifo_counter <= 7'b0;
    else if (r_en && !empty)
    begin
        if (memory[rd_ptr[3:0]][8]==1'b1)
             fifo_counter <= memory[rd_ptr[3:0]][7:2] + 1'b1;
        else if (fifo_counter !=0)
             fifo_counter <= fifo_counter - 1'b1;
    end
end

always @ (posedge clk)
begin
    if((!rst) || (soft_rst))
    begin
        for(i=0;i< depth;i=i+1)
        memory[i] <= 9'b0;
    end

    if (w_en && !full)
        {memory[wr_ptr[3:0]][8],memory[wr_ptr[3:0]][7:0]} = {lfd_temp,din};
end

always @ (posedge clk)
begin
    if(!rst)
        dout <= 8'b0;

    if(soft_rst)
        dout <= 8'bz;

    if ((fifo_counter==0) && (dout!=0))
        dout <= 8'bz;

    if(r_en && ~empty)
        dout <= memory[rd_ptr[3:0]];
end

assign empty = (rd_ptr == wr_ptr) ? 1'b1:1'b0;
assign full = (wr_ptr == {~rd_ptr[4],rd_ptr[3:0]}) ? 1'b1:1'b0;  

endmodule