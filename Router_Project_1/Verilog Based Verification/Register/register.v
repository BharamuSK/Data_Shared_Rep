module register(clk,rst,pkt_valid,din,fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg,error,parity_done,low_pkt_valid,dout);

input clk;

input rst;

input pkt_valid;

input [7:0]din;

input fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg;

output reg low_pkt_valid,error;

output reg parity_done;

output reg [7:0]dout;


reg [7:0] Header_byte, fifo_full_state_byte,Internal_parity,Packet_parity;

//Storing the data in Header Byte and Fifo_state Byte 
always @(posedge clk)
begin
    if(!rst)
    begin
        {Header_byte,fifo_full_state_byte}<=0;
    end
    else
    begin
        if(pkt_valid && detect_add)
        begin
            Header_byte <= din;
        end
        else if(ld_state && fifo_full)
        begin
            fifo_full_state_byte <= din;
        end
    end
    
end

// Dout Logic
always @(posedge clk)
begin
    if(!rst)
    begin
        dout <= 0;
    end
    else if(lfd_state)
    begin
        dout<=Header_byte;
    end
    else if(ld_state && (!fifo_full))
    begin
        dout<=din;
    end
    else if(laf_state)
    begin
        dout<=fifo_full_state_byte;
    end

end


// Parity Logic
always @(posedge clk)
begin
    if(!rst)
    begin
        parity_done <= 1'b0;
    end
    else if(ld_state && ~pkt_valid && ~fifo_full)
    begin
        parity_done<=1'b1;
    end
    else if(laf_state && ~parity_done && low_pkt_valid)
    begin
        parity_done<=1'b1;
    end
    else if(detect_add)
    begin
        parity_done<=0;
    end
end


// Low Packet Valid Logic
always @(posedge clk)
begin
    if(!rst)
    begin
        low_pkt_valid <=1'b0;
    end
    else
    begin
        if((ld_state && !pkt_valid) || (laf_state && ~parity_done && ~pkt_valid))
        begin
            low_pkt_valid <= 1'b1;
        end
        else if(rst_int_reg)             //When The State is in Check Parity is Done Then Parity will be one then rst_int_reg=1
        begin        
            low_pkt_valid <= 1'b0;
        end
    end
end


//packet parity
always @(posedge clk)
begin
    if(!rst)
    begin
        Packet_parity <=0;
    end
    else if((ld_state && ~pkt_valid && ~fifo_full)  || (laf_state && low_pkt_valid && ~parity_done))
    begin
        Packet_parity <=din;
    end
    else if(~pkt_valid && rst_int_reg)
    begin
        Packet_parity <= 0;
    end
    else
    begin
        if(detect_add)
        begin
            Packet_parity <=0;
        end
    end

end


//Internal Parity
always @(posedge clk)
begin
    if(!rst)
    begin
        Internal_parity <= 8'b0;
    end
    else if(detect_add)
    begin
        Internal_parity <= 8'b0;
    end
    else if(lfd_state)
    begin
        Internal_parity <=Internal_parity ^ Header_byte;
    end
    else if(ld_state && pkt_valid && ~full_state)
    begin
        Internal_parity <= Internal_parity ^ din;
    end
    else if(~pkt_valid && rst_int_reg)
    begin
        Internal_parity <=0;
    end

end


always @ (posedge clk)
begin
    if (!rst)
    begin
        error <= 1'b0;
    end
    else if ((parity_done) && (Packet_parity != Internal_parity))
    begin
        error <= 1'b1;
    end
    else if(detect_add)
    begin
        error <= 1'b0;
    end
end


endmodule