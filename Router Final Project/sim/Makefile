
# #Makefile for UVM Testbench
# RTL = ../rtl/*
# SVTB =  ../tb/router_top_tb.sv
# INC = +incdir+../tb +incdir+../test +incdir+../wr_agt_top +incdir+../rd_agt_top 
# # INC = +incdir+../wr_agt_top +incdir+../rd_agt_top +incdir+../test +incdir+../tb +incdir+../src 

# SVTB1 = ../test/router_pkg.sv
# # COVOP= -dbg -coverage sba
# work = work
# VSIMOPT= +access +r -sva 
# VSIMBATCH = -acdb_file mem_cov.acdb
# VSIMBATCH1 = -c -acdb_file mem_cov1.acdb -do "log -rec *;run -all;exit"
# VSIMBATCH2 = -c -acdb_file mem_cov2.acdb -do "log -rec *;;run -all;exit"
# VSIMBATCH3 = -c -acdb_file mem_cov3.acdb -do "log -rec *;;run -all;exit"
# VSIMBATCH4 = -c -acdb_file mem_cov4.acdb -do "log -rec *;;run -all;exit"

# lib:
# 	vlib $(work)
# 	vmap work $(work)

# sv_cmp:clean  lib comp0

# run_sim:
# 	vsim $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH1) -sv_seed random -l s.log work.top   +UVM_TESTNAME=ram_ten_addr_test 
# 	# vsim -c -do "acdb report -db mem_cov1.acdb -html -o mem_cov1.html" 
# gui:
# 	vsim& 	

# comp0:
# 	vlog -work $(work) $(RTL) $(INC) $(SVTB1) $(SVTB)

# run_test: sv_cmp
# 	vsim  $(VSIMBATCH1) $(VSIMOPT) $(VSIMCOV)  -sva -sv_seed random -l test1_sim.log work.top +UVM_OBJECTION_TRACE +UVM_TESTNAME=router_test_c1 +UVM_VERBOSITY=UVM_MEDIUM #The Default Verbosity is medium
# 	vsim -c -do "acdb report -db mem_cov1.acdb -html -o mem_cov1.html;exit"   

# run_test1:sv_cmp
# 	vsim  $(VSIMBATCH2) $(VSIMOPT) $(VSIMCOV)  -sva -sv_seed random -l test2_sim.log work.top +UVM_OBJECTION_TRACE +UVM_TESTNAME=ram_ten_addr_test +UVM_VERBOSITY=UVM_MEDIUM #The Default Verbosity is medium
# 	vsim -c -do "acdb report -db mem_cov1.acdb -html -o mem_cov2.html;exit" 

# run_test2:
# 	vsim  $(VSIMBATCH3) $(VSIMOPT) $(VSIMCOV)  -sva -sv_seed random -l test3_sim.log work.top +UVM_OBJECTION_TRACE +UVM_TESTNAME=ram_odd_addr_test +UVM_VERBOSITY=UVM_MEDIUM #The Default Verbosity is medium
# 	vsim -c -do "acdb report -db mem_cov2.acdb -html -o mem_cov3.html;exit" 

# run_test3:
# 	vsim  $(VSIMBATCH4) $(VSIMOPT) $(VSIMCOV)  -sva -sv_seed random -l test4_sim.log work.top +UVM_OBJECTION_TRACE +UVM_TESTNAME=ram_even_addr_test +UVM_VERBOSITY=UVM_MEDIUM #The Default Verbosity is medium
# 	vsim -c -do "acdb report -db mem_cov3.acdb -html -o mem_cov4.html;exit" 

# clean:
# 	rm -rf modelsim.* transcript* *log* work vsim.wlf fcover* covhtml* mem_cov*
# 	clear
# report:
# 	vsim -c -do "acdb merge -cov sbfa -i mem_cov1.acdb -i mem_cov2.acdb -i mem_cov3.acdb -o mem_cov_merged.acdb;exit"

# rep:
# 	vsim -c -do "acdb report -db mem_cov_merged.acdb -html -o mem_cov_merged.html;exit" 

# regress: clean run_test run_test1 run_test2 run_test3 report rep cov

# cov:
# 	firefox mem_cov_merged.html&

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
        @echo "! USAGE                  --  make target                                                                   !"
        @echo "! clean                  =>  clean the earlier log and intermediate files.                                 !"
        @echo "! sv_cmp         =>  Create library and compile the code.                                                  !"
        @echo "! run_sim    =>  run the simulation in batch mode.                                                         !"
        @echo "! run_test               =>  clean, compile & run the simulation for  in batch mode.     !"
        @echo "! run_test1      =>  clean, compile & run the simulation for  in batch mode.                     !"
        @echo "! view_wave1 =>  To view the waveform of                                                                   !"                                                                                                                       !"
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
