// One sequencer can start many sequences
// `uvm_do(), `uvm_do_with() to run transactions having default priority (-1)
// `uvm_do_pri(), `uvm_do_pri_with() can specify transaction priority. 
// The priority value must be greater or equal to -1.  the higher priority with the greater value  
task my_case0::main_phase(uvm_phase phase);
  sequence0 seq0;
  sequence1 seq1;
  seq0 = new("seq0");
  seq0.starting_phase = phase;
  seq1 = new("seq1");
  seq1.starting_phase = phase;
  fork
    //sequencer starts seq0 and seq1
    seq0.start(env.i_agt.sqr);
    seq1.start(env.i_agt.sqr);
  join
endtask

class sequence0 extends uvm_sequence #(my_transaction);
  virtual task body();
    repeat (5) begin
      `uvm_do(m_trans)
      // `uvm_do_pri(m_trans, 100)
      `uvm_info("sequence0", "send one transaction", UVM_MEDIUM)
    end
    #100;
  endtask
  `uvm_object_utils(sequence0)
endclass

class sequence1 extends uvm_sequence #(my_transaction);
  virtual task body();
    repeat (5) begin
      `uvm_do_with(m_trans, {m_trans.pload.size < 500;})
      // `uvm_do_pri_with(m_trans, 200, {m_trans.pload.size < 500;})
      `uvm_info("sequence1", "send one transaction", UVM_MEDIUM)
    end
    #100
  endtask
  `uvm_object_utils(sequence1)
endclass
