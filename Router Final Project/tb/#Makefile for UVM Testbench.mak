#Makefile for UVM Testbench
RTL= ../rtl/*
work= work #library name
SVTB1= ../tb/router_top_tb.sv
INC = +incdir+../tb +incdir+../test +incdir+../wr_agt_top +incdir+../rd_agt_top
SVTB2 = ../test/router_pkg.sv
VSIMOPT= -vopt -voptargs=+acc 
VSIMCOV= -coverage -sva 
VSIMBATCH1= -c -do  " log -r /* ;run -all; exit"

help:
	@echo =============================================================================================================
	@echo "! USAGE   		--  make target                             																			!"
	@echo "! clean   		=>  clean the earlier log and intermediate files.       													!"
	@echo "! sv_cmp    	=>  Create library and compile the code.                   												!"
	@echo "! run_sim    =>  run the simulation in batch mode.                   													!"
	@echo "! run_test		=>  clean, compile & run the simulation for  in batch mode.	!" 
	@echo "! run_test1	=>  clean, compile & run the simulation for  in batch mode.			!" 
	@echo "! view_wave1 =>  To view the waveform of 	    																!"   															!" 
	@echo ====================================================================================================================

sv_cmp:
	vlib $(work)
	vmap work $(work)
	vlog -work $(work) $(RTL) $(INC) $(SVTB2) $(SVTB1) 	
	
run_test:sv_cmp
	vsim $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH1)  -wlf wave_file1.wlf -l test1.log  -sv_seed random  work.top +UVM_TESTNAME=router_test_c1  
	
view_wave1:
	vsim -view wave_file1.wlf
	
clean:
	rm -rf transcript* *log*  vsim.wlf fcover* covhtml* mem_cov* *.wlf modelsim.ini
	clear
