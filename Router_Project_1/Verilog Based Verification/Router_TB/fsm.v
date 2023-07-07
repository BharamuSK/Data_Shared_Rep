module fsm(din,clk,rst,pkt_valid,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,soft_rst_0,soft_rst_1,soft_rst_2,parity_done,low_pkt_valid,wr_en_reg,detect_add,ld_state,laf_state,lfd_state,full_state,rst_in_reg,busy);


parameter DECODE_ADDRESS =3'b000,
          LOAD_FIRST_DATA =3'b001,
          LOAD_DATA =3'b010,
          FIFO_FULL_STATE =3'b011,
          LOAD_AFTER_FULL =3'b100,
          LOAD_PARITY =3'b101,
          CHECK_PARITY_ERROR=3'b110,
          WAIT_TILL_EMPTY =3'b111;

input clk,rst,pkt_valid;  // Input from Source network 

input [1:0]din;           

// From Synchronizer

input fifo_full;
 

// From FIFO
input fifo_empty_0,fifo_empty_1,fifo_empty_2;

//Synchronizer
input soft_rst_0,soft_rst_1,soft_rst_2;


//From Register Block
input parity_done;       

input low_pkt_valid;   


output wr_en_reg;

output detect_add,ld_state,laf_state,lfd_state,full_state,rst_in_reg;

output busy;



reg [2:0] present_state, next_state;


// Present logic

always @(posedge clk)
begin
    if(!rst)
    begin
        present_state <= DECODE_ADDRESS;
    end
    else if(((soft_rst_0) && (din == 2'b00))|| ((soft_rst_1) && (din==2'b01)) || ((soft_rst_2) && (din==2'b10)))
    begin
        present_state <= DECODE_ADDRESS;
    end
    else
    begin
        present_state <= next_state;
    end

end


//Next State Decoder Logic


always@(*)
begin
    if(din != 2'b11)
        begin
            next_state=DECODE_ADDRESS;
            case(present_state)
                DECODE_ADDRESS: if(((pkt_valid & (din[1:0]==0) & fifo_empty_0) | (pkt_valid & (din[1:0]==1) & fifo_empty_1) | (pkt_valid & (din[1:0]==2) & fifo_empty_2)))
                                    begin
                                        next_state <= LOAD_FIRST_DATA;
                                    end
                                else if(((pkt_valid & (din[1:0]==0) & !fifo_empty_0) | (pkt_valid & (din[1:0]==1) & !fifo_empty_1) | (pkt_valid & (din[1:0]==2) & !fifo_empty_2)))
                                    begin
                                        next_state <= WAIT_TILL_EMPTY;
                                    end
                                else
                                    begin
                                        next_state <= DECODE_ADDRESS;
                                    end
                
                LOAD_FIRST_DATA: next_state <= LOAD_DATA;

                LOAD_DATA: begin
                            if((!fifo_full) && (!pkt_valid))
                                begin
                                    next_state <= LOAD_PARITY;
                                end
                            else if(fifo_full)
                                begin
                                    next_state <= FIFO_FULL_STATE;
                                end
                            else
                                begin
                                    next_state <= LOAD_DATA;
                                end
                            end    
                FIFO_FULL_STATE:begin 
                                if(!fifo_full)
                                    begin
                                        next_state <= LOAD_AFTER_FULL;
                                    end
                                else
                                    begin
                                        next_state <=FIFO_FULL_STATE;
                                    end
                                end

                LOAD_AFTER_FULL:begin
                                 if((!parity_done) && (low_pkt_valid))
                                    begin
                                        next_state <= LOAD_PARITY;
                                    end
                                else if((!parity_done) && (!low_pkt_valid))
                                    begin
                                        next_state <= LOAD_DATA;
                                    end
                                else if(parity_done && low_pkt_valid)
                                    begin
                                        next_state <= DECODE_ADDRESS;
                                    end
                                end   
                
                LOAD_PARITY: begin 
                                next_state<= CHECK_PARITY_ERROR;
                             end 

                CHECK_PARITY_ERROR: begin
                                    if(fifo_full)
                                        begin
                                            next_state <= FIFO_FULL_STATE;
                                        end
                                    else if(!fifo_full)
                                        begin
                                            next_state <= DECODE_ADDRESS;
                                        end
                                    end

                WAIT_TILL_EMPTY:begin 
                                if((din == 0 && fifo_empty_0) || (din == 1 && fifo_empty_1) || (din == 2 && fifo_empty_2))
                                    begin
                                        next_state <= LOAD_FIRST_DATA;
                                    end
                                 else 
                                    begin
                                        next_state <= WAIT_TILL_EMPTY;
                                    end
                                end
            endcase
        end
 end
                 

assign detect_add =(present_state == DECODE_ADDRESS)?1'b1:1'b0;

assign ld_state = (present_state == LOAD_DATA) ? 1'b1 : 1'b0;

assign lfd_state = (present_state == LOAD_FIRST_DATA) ? 1'b1 : 1'b0;

assign laf_state =(present_state == LOAD_AFTER_FULL) ? 1'b1 : 1'b0;

assign full_state = (present_state == FIFO_FULL_STATE) ? 1'b1 : 1'b0;

assign rst_in_reg = (present_state == CHECK_PARITY_ERROR) ? 1'b1 :1'b0;

assign  wr_en_reg = ((present_state==LOAD_DATA || present_state==LOAD_AFTER_FULL || present_state==LOAD_PARITY))?1'b1:1'b0;

assign busy = ((present_state == LOAD_DATA) ||  (present_state == DECODE_ADDRESS)) ? 1'b0 :1'b1;




endmodule