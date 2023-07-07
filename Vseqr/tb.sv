// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples


`include "uvm_macros.svh"
import uvm_pkg::*;





typedef enum{SEQ_1, SEQ_2_LOCK, SEQ_3}seq_enum;

//***************SEQ_ITEM**************************************

class seq_item extends uvm_sequence_item;
 
  rand seq_enum senum;
  `uvm_object_utils_begin(seq_item)
  `uvm_field_enum(seq_enum, senum, UVM_DEFAULT)
  `uvm_object_utils_end
 
  function new(string name = "seq_item");
    super.new(name);
  endfunction
 
  function string display();
    $sformatf("seq_item = %0s", senum.name());
  endfunction
 
endclass

//****************SEQUENCER************************************

class sequencer_1 extends uvm_sequencer #(seq_item);
  `uvm_component_utils(sequencer_1)
 
  function new(string name = "sequencer_1", uvm_component parent = null);
    super.new(name, parent);
  endfunction
 
endclass

class sequencer_2 extends uvm_sequencer #(seq_item);
  `uvm_component_utils(sequencer_2)
 
  function new(string name = "sequencer_2", uvm_component parent = null);
    super.new(name, parent);
  endfunction
 
endclass

class virtual_seqr extends uvm_sequencer;
  `uvm_component_utils(virtual_seqr)
  sequencer_1 seqr_1;
  sequencer_2 seqr_2;

  function new(string name = "virtual_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction
endclass

//****************DRIVER***************************************

class driver extends uvm_driver #(seq_item);
  `uvm_component_utils(driver)
 
  function new(string name = "driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
 
  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      $display($time, "Driving sequence %s", req.display());
      #10;
      seq_item_port.item_done();
    end
  endtask
 
endclass

class driver_1 extends driver;
  `uvm_component_utils(driver_1)
 
  function new(string name = "driver_1", uvm_component parent = null);
    super.new(name, parent);
  endfunction
 
  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      $display($time, "Driving sequence %s", req.display());
      #10;
      seq_item_port.item_done();
    end
  endtask
 
endclass

class driver_2 extends driver;
  `uvm_component_utils(driver_2)
 
  function new(string name = "driver_2", uvm_component parent = null);
    super.new(name, parent);
  endfunction
 
  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      $display($time, "Driving sequence %s", req.display());
      #10;
      seq_item_port.item_done();
    end
  endtask
 
endclass

//************************AGENT********************************

class agent_1 extends uvm_agent;
  sequencer_1 seqr_1;
  driver_1 drv_1;
  `uvm_component_utils(agent_1)
 
  function new(string name = "agent_1", uvm_component parent = null);
    super.new(name, parent);
  endfunction
 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seqr_1 = sequencer_1::type_id::create("seqr_1", this);
    drv_1 = driver_1::type_id::create("drv_1", this);
  endfunction
 
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv_1.seq_item_port.connect(seqr_1.seq_item_export);
  endfunction
 
endclass

class agent_2 extends uvm_agent;
  sequencer_2 seqr_2;
  driver_2 drv_2;
  `uvm_component_utils(agent_2)
 
  function new(string name = "agent_2", uvm_component parent = null);
    super.new(name, parent);
  endfunction
 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seqr_2 = sequencer_2::type_id::create("seqr_2", this);
    drv_2 = driver_2::type_id::create("drv_2", this);
  endfunction
 
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv_2.seq_item_port.connect(seqr_2.seq_item_export);
  endfunction
 
endclass

//*************************SEQ_1*******************************

class seq_1 extends uvm_sequence #(seq_item);
  seq_item sitem;
  `uvm_object_utils(seq_1)
 
  function new(string name = "seq_1");
    super.new(name);
  endfunction
 
  virtual task body();
    repeat(4)begin
      `uvm_info(get_type_name(), $sformatf("SEQ_1 in sent"),UVM_NONE)
      `uvm_do_with(req, {senum == SEQ_1;})
      req.print();
    end
  endtask
 
endclass

//********************SEQ_2************************************

class seq_2 extends uvm_sequence #(seq_item);
  seq_item sitem;
  `uvm_object_utils(seq_2)
 
  function new(string name = "seq_2");
    super.new(name);
  endfunction
 
  virtual task body();
    lock();
    repeat(4)begin
      `uvm_info(get_type_name(), $sformatf("SEQ_2_LOCK in sent"),UVM_NONE)
      `uvm_do_with(req, {senum == SEQ_2_LOCK;})
      req.print();
    end
    unlock();
  endtask
 
endclass

//********************SEQ_3************************************

/*class seq_3 extends uvm_sequence #(seq_item);
  seq_item sitem;
  `uvm_object_utils(seq_3)
 
  function new(string name = "seq_3");
    super.new(name);
  endfunction
 
  virtual task body();
    grab();
    repeat(4)begin
      `uvm_info(get_type_name(), $sformatf("SEQ_3 in sent"),UVM_NONE)
      `uvm_do_with(req, {senum == SEQ_3;})
      req.print();
    end
    ungrab();
  endtask
 
endclass
*/



//************************ENV**********************************
class enviroment extends uvm_env;
  agent_1 agnt_1;
  agent_2 agnt_2;
 
  virtual_seqr v_seqr;
  `uvm_component_utils(enviroment)
 
  function new(string name = "enviroment", uvm_component parent = null);
    super.new(name, parent);
  endfunction
 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agnt_1 = agent_1::type_id::create("agnt_1", this);
    agnt_2 = agent_2::type_id::create("agnt_2", this);
    v_seqr = virtual_seqr::type_id::create("v_seqr", this);
  endfunction
 
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    v_seqr.seqr_1=agnt_1.seqr_1;
    v_seqr.seqr_2=agnt_2.seqr_2;
  endfunction
 
endclass

//*********VIRTUAL_SEQR****************************************

class virt_seq extends uvm_sequence #(seq_item);
 
  seq_1 s_1;
  seq_2 s_2;
  //seq_3 s_3;
  sequencer_1 seqr_1;
  sequencer_2 seqr_2;
  //agent agnt;
  `uvm_object_utils(virt_seq)
 
 
  function new(string name = "virt_seq");
    super.new(name);
  endfunction

  task body();
    enviroment envr;
    s_1 = seq_1::type_id::create("s_1");
    s_2 = seq_2::type_id::create("s_2");
    //s_3 = seq_3::type_id::create("s_3");
   
    if(!$cast(envr, uvm_top.find("uvm_test_top.envr")))
      `uvm_error(get_name(), "envr is not found");
    s_1.start(envr.v_seqr.seqr_1);
    s_2.start(envr.v_seqr.seqr_2);
  endtask
endclass
//************************TEST*********************************

class test extends uvm_test;
  enviroment envr;
 
  `uvm_component_utils(test)
  virt_seq v_seq;
 
  function new(string name = "test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    envr = enviroment::type_id::create("envr", this);
  endfunction
 
  task run_phase(uvm_phase phase);
    v_seq = virt_seq::type_id::create("v_seq");
    phase.raise_objection(this);
    v_seq.start(envr.v_seqr);
    phase.drop_objection(this);
  endtask
endclass

//***************MODULE****************************************

module top();
  initial begin
    run_test("test");
  end
endmodule