vlog -work work -vopt -sv -stats=none {C:/Users/admin/Desktop/VLSI Projects/SV Based FIFO Verification/fifo_tb.sv}
vlog -work work -vopt -stats=none {C:/Users/admin/Desktop/VLSI Projects/SV Based FIFO Verification/fifo.v}
vsim -voptargs=+acc work.fifo_tb
add wave -position insertpoint sim:/fifo_tb/dut/*
run -all
