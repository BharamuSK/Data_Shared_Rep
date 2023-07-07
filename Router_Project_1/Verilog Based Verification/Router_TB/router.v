module router(clock,reset,pkt_valid,read_en_0,read_en_1,read_en_2,din,valid_out_0,valid_out_1,valid_out_2,error,busy,dout_0,dout_1,dout_2);

input clock,reset,pkt_valid,read_en_0,read_en_1,read_en_2;

input [7:0]din;

output valid_out_0,valid_out_1,valid_out_2,error,busy;


output [7:0]dout_0,dout_1,dout_2;

wire [2:0]wr_en;

wire [7:0]dout;


fsm FSM1(.din(din[1:0]),.clk(clock),.rst(reset),.pkt_valid(pkt_valid),.fifo_full(fifo_full),.fifo_empty_0(empty_0),.fifo_empty_1(empty_1),.fifo_empty_2(empty_2),.soft_rst_0(soft_rst_0),.soft_rst_1(soft_rst_1),.soft_rst_2(soft_rst_2),.parity_done(parity_done),.low_pkt_valid(low_pkt_valid),.wr_en_reg(wr_en_reg),.detect_add(detect_add),.ld_state(ld_state),.laf_state(laf_state),.lfd_state(lfd_state),.full_state(full_state),.rst_in_reg(rst_in_reg),.busy(busy));

// fsm(din,clk,rst,pkt_valid,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,soft_rst_0,soft_rst_1,soft_rst_2,parity_done,low_pkt_valid,wr_en_reg,detect_add,ld_state,laf_state,lfd_state,full_state,rst_in_reg,busy);


register REG1(.clk(clock),.rst(reset),.pkt_valid(pkt_valid),.din(din),.fifo_full(fifo_full),.detect_add(detect_add),.ld_state(ld_state),.laf_state(laf_state),.full_state(full_state),.lfd_state(lfd_state),.rst_int_reg(rst_in_reg),.error(error),.parity_done(parity_done),.low_pkt_valid(low_pkt_valid),.dout(dout));
// register  (clk,rst,pkt_valid,din,fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg,error,parity_done,low_pkt_valid,dout);


synchronizer SYNC1(.clk(clock),.rst(reset),.wr_en_reg(wr_en_reg),.wr_en(wr_en),.din(din[1:0]),.det_addr(detect_add),.f_0(full_0),.f_1(full_1),.f_2(full_2),.e_0(empty_0),.e_1(empty_1),.e_2(empty_2),.re_0(read_en_0),.re_1(read_en_1),.re_2(read_en_2),.fifo_full(fifo_full),.valid_out_0(valid_out_0),.valid_out_1(valid_out_1),.valid_out_2(valid_out_2),.soft_rst0(soft_rst_0),.soft_rst1(soft_rst_1),.soft_rst2(soft_rst_2));
// synchronizer(clk,rst,wr_en_reg,wr_en,din,det_addr,f_0,f_1,f_2,e_0,e_1,e_2,re_0,re_1,re_2,fifo_full,valid_out_0,valid_out_1,valid_out_2,soft_rst0,soft_rst1,soft_rst2)


R_fifo  FIFO1(.din(dout),.clk(clock),.rst(reset),.soft_rst(soft_rst_0),.w_en(wr_en[0]),.r_en(read_en_0),.lfd_state(lfd_state),.dout(dout_0),.empty(empty_0),.full(full_0));

R_fifo  FIFO2(.din(dout),.clk(clock),.rst(reset),.soft_rst(soft_rst_1),.w_en(wr_en[1]),.r_en(read_en_1),.lfd_state(lfd_state),.dout(dout_1),.empty(empty_1),.full(full_1));

R_fifo  FIFO3(.din(dout),.clk(clock),.rst(reset),.soft_rst(soft_rst_2),.w_en(wr_en[2]),.r_en(read_en_2),.lfd_state(lfd_state),.dout(dout_2),.empty(empty_2),.full(full_2));


//R_fifo(din,clk,rst,soft_rst,w_en,r_en,lfd_state,dout,empty,full);


endmodule