`include "uvm_macros.svh"
import uvm_pkg::*;


///////////////////////////////////////
////////////APB Side Config File///////
class apb_agent_config extends uvm_object;

    `uvm_object_utils(apb_agent_config)
    int no_of_dst=1;

    function new(string name="apb_agent_config");
        super.new(name);
    endfunction

endclass

///////////////////////////////////////
////////////AHB Side Config File///////
class ahb_agent_config extends uvm_object;

    `uvm_object_utils(apb_agent_config)
    int no_of_src=1;

    function new(string name="ahb_agent_config");
        super.new(name);
    endfunction

endclass

///////////////////////////////////////
//////////////APB - Side///////////////
    class apb_monitor extends uvm_monitor;

        `uvm_component_utils(apb_monitor)

        function new(string name="apb_monitor",uvm_component parent);
            super.new(name,parent);
        endfunction

    endclass

    class apb_driver extends uvm_driver;

        `uvm_component_utils(apb_driver)

        function new(string name="apb_driver",uvm_component parent);
            super.new(name,parent);
        endfunction

    endclass

    class apb_seqr extends uvm_sequencer;

        `uvm_component_utils(apb_seqr)

        function new(string name="apb_seqr",uvm_component parent);
            super.new(name,parent);
        endfunction

    endclass

///////////////////////////////////////
////////////APB Agent/////////////////

class apb_agent extends uvm_agent;
        `uvm_component_utils(apb_agent)
        apb_driver d;
        apb_monitor m;
        apb_seqr s;

        function new(string name="apb_agent",uvm_component parent);
            super.new(name,parent);
        endfunction


        virtual function void build_phase(uvm_phase phase);
                    super.build_phase(phase);
                    d=apb_driver::type_id::create("d",this);
                    m=apb_monitor::type_id::create("m",this);
                    s=apb_seqr::type_id::create("s",this);
                endfunction 

endclass

/////////////APB_Agent_Top////////////
class apb_agent_top extends uvm_agent;

    `uvm_component_utils(apb_agent_top)
    apb_agent a[];
    apb_agent_config ap_cfg;

    function new(string name="apb_agent_top",uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                if(!uvm_config_db#(apb_agent_config)::get(this,"","apb_agent_config",ap_cfg))
		        begin    
                    `uvm_fatal("apb_agnt_config","cannot get config data");
                end
                a=new[ap_cfg.no_of_dst];
                foreach(a[i])
                begin
                    a[i]=apb_agent::type_id::create($sformatf("a[%0d]",i),this);
                end
            endfunction
endclass

////////////////////////////////////////
/////////////AHB Side///////////////////
    class ahb_monitor extends uvm_monitor;

        `uvm_component_utils(ahb_monitor)

        function new(string name="ahb_monitor",uvm_component parent);
            super.new(name,parent);
        endfunction

    endclass

    class ahb_driver extends uvm_driver;

        `uvm_component_utils(ahb_driver)

        function new(string name="ahb_driver",uvm_component parent);
            super.new(name,parent);
        endfunction

    endclass

    class ahb_seqr extends uvm_sequencer;

        `uvm_component_utils(ahb_seqr)

        function new(string name="ahb_seqr",uvm_component parent);
            super.new(name,parent);
        endfunction

    endclass

///////////////////////////////////////
////////////AHB--Agent/////////////////

class ahb_agent extends uvm_agent;
    `uvm_component_utils(ahb_agent)
    ahb_driver dh;
    ahb_monitor mh;
    ahb_seqr sh;

    function new(string name="ahb_agent",uvm_component parent);
        super.new(name,parent);
    endfunction


    virtual function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                dh=ahb_driver::type_id::create("dh",this);
                mh=ahb_monitor::type_id::create("mh",this);
                sh=ahb_seqr::type_id::create("sh",this);
            endfunction 

endclass

/////////////ahb_agent_top////////////
class ahb_agent_top extends uvm_agent;

    `uvm_component_utils(ahb_agent_top)
    ahb_agent b[];
    ahb_agent_config ah_cfg;

    function new(string name="ahb_agent_top",uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                if(!uvm_config_db#(ahb_agent_config)::get(this,"","ahb_agent_config",ah_cfg))
		        begin
                    `uvm_fatal("apb_agnt_config","cannot get config data");
                end
                b=new[ah_cfg.no_of_src];
                foreach(b[i])
                begin
                    b[i]=ahb_agent::type_id::create($sformatf("b[%0d]",i),this);
                end
            endfunction
endclass


////////////////Score board////////////
class sb extends uvm_scoreboard;

    `uvm_component_utils(sb)

    function new(string name="sb",uvm_component parent);
        super.new(name,parent);
    endfunction

endclass

////////////////////////////////////////
////////////// Env /////////////////////
class env extends uvm_env;

    `uvm_component_utils(env)

    apb_agent_top apb;
    ahb_agent_top ahb;

    apb_agent_config apb_cfg=new();
    ahb_agent_config ahb_cfg=new(); 

    sb sc;
    function new(string name="env",uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_config_db#(apb_agent_config)::set(this,"*","apb_agent_config",apb_cfg);
        uvm_config_db#(ahb_agent_config)::set(this,"*","ahb_agent_config",ahb_cfg);
        apb=apb_agent_top::type_id::create("apb",this);
        ahb=ahb_agent_top::type_id::create("ahb",this);

        sc=sb::type_id::create("sc",this);
    endfunction 

endclass

////////////////////////////////////////
////////////////Test////////////////////
class test extends uvm_test;

    `uvm_component_utils(test)
    env e;

    function new(string name="test", uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                e=env::type_id::create("e",this);
            endfunction



    virtual function void end_of_elaboration_phase(uvm_phase phase);
                super.end_of_elaboration_phase(phase);
                uvm_top.print_topology;
            
            endfunction 
            
endclass

///////////////////////////////////////////////
/////////////Module Top////////////////////////
module tb();

    initial 
        begin
            run_test("test");
        end
   
endmodule