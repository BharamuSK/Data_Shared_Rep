class trascation;
    randc bit wr;
    randc bit re;

    randc bit [7:0] din;
         bit [7:0] dout;
         bit full;
         bit empty;

    constraint abc{wr!=re;
                //    wr dist {0:/50,1:/50};[1:0]:=50
                //    re dist {0:/50,1:/50};
                //           or
                    wr dist {[0:1]:=1};
                    re dist {[0:1]:=1};
                    
                    }

    function void display(input string cls);
        $display("[time=%0t]\t : [%s] : wr=%0b\t re=%0b\t full=%0b\t empty=%0b\t din=%0d\t dout=%0d",$time,cls,wr,re,full,empty,din,dout);
    endfunction

    function trascation copy();
        copy = new();
        copy.wr=this.wr;
        copy.re=this.re;
        copy.din=this.din;
        copy.dout=this.dout;
        copy.full=this.full;
        copy.empty=this.empty;
    endfunction

endclass

interface fi_if();
    
    logic clk;
    logic rst;
    logic wr;
    logic re;
    logic [7:0] din;
    logic [7:0] dout;

    logic full;
    logic empty;

endinterface

class gen;

    trascation tr;

    event next;

    mailbox #(trascation) mbx;

    function new(mailbox #(trascation) mbx);
        this.mbx=mbx;
        tr= new();
    endfunction


    task run();
        repeat(5)
        begin
            tr.randomize();
            mbx.put(tr.copy);
            $display("-----------------------------------------------------------------");
            tr.display("GEN");
            // wait(next.triggered);
            @(next);
        end
    endtask

endclass

class drv;
    trascation tr;
    virtual fi_if f_if;

    event done;


    mailbox #(trascation) mbx;

    function new(mailbox #(trascation) mbx);
        this.mbx=mbx;
    endfunction

     // rst task
    task reset();
        f_if.rst <=1'b1;
        f_if.re  <=1'b0;
        f_if.wr  <=1'b0;
        f_if.din <=0;
        repeat(5) @(posedge f_if.clk);
        f_if.rst <=1'b0;
        $display("[DRV] : DUT Reset Done");

    endtask

    task run();
        forever
            begin
                mbx.get(tr);
                tr.display("DRV");

                f_if.din<= tr.din;
                f_if.wr<= tr.wr;
                f_if.re<= tr.re;

                repeat(2)
                @(posedge f_if.clk);
            end
    endtask

endclass

class mon;

    trascation tr;

    virtual fi_if f_if;

    mailbox #(trascation) mbx;

    function new(mailbox #(trascation) mbx);
        this.mbx=mbx;
        // tr= new();
    endfunction
    
    task run();
        tr= new();
        forever
        begin
            repeat(2)
            @(posedge f_if.clk);
            tr.din = f_if.din;
            tr.wr  = f_if.wr;
            tr.re  = f_if.re;
            tr.dout = f_if.dout;
            tr.empty= f_if.empty;
            tr.full = f_if.full;

            mbx.put(tr);

            tr.display("MON");
        end
    endtask

endclass


class sb;

    trascation tr;
    
    event done;

    bit [7:0] di[$];
    bit [7:0] temp;

    mailbox #(trascation) mbx;

    function new(mailbox #(trascation) mbx);
        this.mbx=mbx;
    endfunction

    task run();
        forever
        begin
            mbx.get(tr);
            tr.display("SB");
            
            if(tr.wr == 1'b1)
            begin
                di.push_front(tr.din);
                $display("[SCO] : DATA STORED IN QUEUE :%0d", tr.din);
            end

            if(tr.re == 1'b1)
            begin
                if(tr.empty == 1'b0)
                begin
                    temp = di.pop_back();
                    if(tr.dout == temp)
                        $display("[SCO] : DATA MATCH");
                    else
                        $display("[SCO] : DATA MISMATCH");
                end
                else
                begin
                    $display("[SCO] : FIFO Empty");
                end
            end
            
            $display("-----------------------------------------------------------------");
            ->done;
        end
    endtask

endclass


class env;

    virtual fi_if f_if;
        
    gen g;
    drv d;

    mon m;
    sb s;

    mailbox #(trascation) mbx;
    mailbox #(trascation) mon_mbx;
    
    event done;

    function new(virtual fi_if f_if);
        mbx=new();
        g=new(mbx);
        d=new(mbx);
        
        mon_mbx=new();
        m=new(mon_mbx);
        s=new(mon_mbx);

        this.f_if=f_if;

        d.f_if=f_if;
        m.f_if=f_if;

        g.next=done;
        s.done=done;

    endfunction

    task pre_test();
        d.reset();
    endtask
    
    task test();
        fork
            g.run();
            d.run();
            m.run();
            s.run();
        join_any
    endtask
    
    task post_test();
        // wait(g.done.triggered);  
        #500;
        $finish();
    endtask
    
    task run();
        pre_test();
        test();
        post_test();
    endtask

endclass



module fifo_tb();

    fi_if f_if();

    fifo dut(.clock(f_if.clk), .rd(f_if.re), .wr(f_if.wr), .full(f_if.full), .empty(f_if.empty), .data_in(f_if.din), .data_out(f_if.dout), .rst(f_if.rst));

    env e;

    initial
    begin
        f_if.clk=0;
        forever #10 f_if.clk= ~ f_if.clk;
    end
    
    initial 
    begin
        e = new(f_if);
        e.run();
    end

endmodule

    

