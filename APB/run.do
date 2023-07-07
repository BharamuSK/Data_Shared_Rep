vlog -work work -vopt -sv -stats=none {C:/Users/admin/Desktop/VLSI Projects/APB/axi_top.svh} 
vsim -voptargs=+acc work.apb_tb -l apb_tb.log

add wave -position insertpoint sim:/apb_tb/*

run -all
