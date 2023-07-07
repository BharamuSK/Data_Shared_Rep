module synchronizer(clk,rst,wr_en_reg,wr_en,din,det_addr,f_0,f_1,f_2,e_0,e_1,e_2,re_0,re_1,re_2,fifo_full,valid_out_0,valid_out_1,valid_out_2,soft_rst0,soft_rst1,soft_rst2);

input clk,rst;

input [1:0] din;   //Used to latch the Address  When the Address detects Decode state to LFD ()
//Load First data of The FIFO Block

input wr_en_reg,det_addr;

input f_0,f_1,f_2;     //From FIFO (Full)

input e_0,e_1,e_2;     //From FIFO  and Its The Inversion Of valid out Signal  (Empty)

input re_0,re_1,re_2;  // From Destination Address

output reg [2:0]wr_en;     // From Output OF FSM  It will high Whenever the Write the Operation is High 

output reg fifo_full;      //Input to The FSM 

output valid_out_0,valid_out_1,valid_out_2;

output reg soft_rst0,soft_rst1,soft_rst2;

reg [1:0]temp;   // Used To validate The address

reg [4:0]timer_0,timer_1,timer_2;   // Need to check read enable signal is high at 30 cycles i.e[5:0]

always @(posedge clk)
begin
    
    if(~rst)
    begin
        // wr_en <=0;
        temp <=2'b11;
    end
    else if(det_addr == 1)
    begin
        temp <= din;
    end
    else
    begin
        
    end
end

// Write_enb_register

// always @(*)
always @(posedge clk)
begin
    if(wr_en_reg)
    begin
        case(temp)
        
            2'b00:wr_en=3'b001;
            2'b01:wr_en=3'b010;
            2'b10:wr_en=3'b100;

            default : wr_en=3'b000;
        endcase
    end
    else
    begin
        wr_en=3'b000;
    end

end


// Fifo_full logic
// always @(*)
always @(posedge clk)

begin
    // if(det_addr == 1)
    // begin
    case(temp)
        2'b00:fifo_full=f_0;
        2'b01:fifo_full=f_1;
        2'b10:fifo_full=f_2;

        default: fifo_full=0;

    endcase
    // end
    

end


//Soft Reset Signals for FIFO

//Soft reset 0

always @(posedge clk)
begin
    if(~rst)
    begin
        timer_0 <=0;
        soft_rst0 <=0;
    end
    else if(valid_out_0)
    begin
        if(~re_0)
        begin
            if(timer_0 == 5'd29)
            begin
                soft_rst0 <= 1'b1;
                timer_0 <= 0;
            end
            else
            begin
                soft_rst0 <= 0;
                timer_0 <= timer_0 +1;
            end
        end

    end

end

//Soft reset 1


always @(posedge clk)
begin
    if(~rst)
    begin
        timer_1 <=0;
        soft_rst1 <=0;
    end
    else if(valid_out_1)
    begin
        if(~re_1)
        begin
            if(timer_1 == 5'd29)
            begin
                soft_rst1 <= 1'b1;
                timer_1 <= 0;
            end
            else
            begin
                soft_rst1 <= 0;
                timer_1 <= timer_1 +1;
            end
        end

    end

end

//Soft reset 2


always @(posedge clk)
begin
    if(~rst)
    begin
        timer_2 <=0;
        soft_rst2 <=0;
    end
    else if(valid_out_2)
    begin
        if(~re_2)
        begin
            if(timer_2 == 5'd29)
            begin
                soft_rst2 <= 1'b1;
                timer_2 <= 0;
            end
            else
            begin
                soft_rst2 <= 0;
                timer_2 <= timer_2 +1;
            end
        end

    end

end

//Valid Out Logic

assign valid_out_0 = ~e_0;

assign valid_out_1 = ~e_1; 

assign valid_out_2 = ~e_2; 


endmodule