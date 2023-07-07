module R_fifo(din,clk,rst,soft_rst,w_en,r_en,lfd_state,dout,full,empty);

    
input clk,w_en,r_en,lfd_state;

input rst,soft_rst;

input [7:0]din;

output reg [7:0]dout;
output  full,empty;


reg temp_lfd;

reg [8:0]mem[0:15];     //Width 9 Bit [8:0]  and Depth is 16bit [0:15]

reg [6:0]fifo_counter;  //To hold the no of payload Max payload length 64bit [6:0] 
// In 8 bit data first 2 bit are Header and 6 Bits are Payload Length 
// i.e 2^6=64 [5:0] and one parity 1 bit also needs to parity byte so [6:0] 

reg [4:0]rd_ptr;
reg [4:0]wr_ptr;

integer i;

//Temprovary Buff////////
/*
always @(posedge clk)
begin
    if(!rst)
    begin
        temp_lfd <= 0;
    end
    else
    begin
        temp_lfd <= lfd_state;
    end
end
*/

// Pointer Increment 
always @(posedge clk)
begin
    if(!rst)
    begin
        rd_ptr <= 5'b00000;
        wr_ptr <= 5'b00000;
    end
    else if (soft_rst)
    begin
        rd_ptr <= 5'b00000;
        wr_ptr <= 5'b00000;
    end
    else
        begin
            if(w_en && ~full)
            begin
                wr_ptr <= wr_ptr+1;
            end
            else
            begin
                wr_ptr <= wr_ptr;
            end
           if(r_en && ~empty)
            begin
                rd_ptr <= rd_ptr+1;
            end
            else
            begin
                rd_ptr <= rd_ptr;
            end
        end
end

//FIFO Down counter Logic

always@(posedge clk)
begin
if(!rst)
    begin
        fifo_counter <=0;
    end
    else if (soft_rst)
    begin
        fifo_counter <=0;
    end
    else if(r_en & ~empty)
    begin
        if(mem[rd_ptr[3:0]][8] == 1'b1)  // Checking The LFD Bit on 8'th Bit
        begin
            fifo_counter <= mem[rd_ptr[3:0]][7:2] + 1; // payload length 5 and 1bit parity
        end
        else if(fifo_counter !=0)
        begin
            fifo_counter <= fifo_counter - 1'b1;
        end

    end

end


// Write Operation

always @(posedge clk)
begin
    if(!rst)
    begin
    for(i=0; i<16 ;i=i+1 )
    begin
        mem[i]<=0;
    end
    end
    else if(soft_rst)
    begin
        for(i=0; i<16 ;i=i+1 )
        begin
             mem[i]<=0;
        end
    end
    else
    begin
    if(w_en && !full)
    begin
		 {mem[wr_ptr[3:0]][8],mem[wr_ptr[3:0]][7:0]}<= {lfd_state,din};
    end
    end
end


// Read Operatoin

always @(posedge clk)
begin
    if(!rst)
        begin
            dout<=0;
        end
    else if(soft_rst)
        begin
            dout <= 8'dz;
        end
    else if((fifo_counter  == 0 ) && (dout != 0))
        begin
            dout <= 8'dz;
        end
    else if(r_en && (~empty))//empty ==0)
        begin
            dout<=mem[rd_ptr[3:0]];
        end
end


assign empty=(rd_ptr==wr_ptr)?1'b1:1'b0;

assign full=(wr_ptr=={~rd_ptr[4],rd_ptr[3:0]})?1'b1:1'b0;

endmodule