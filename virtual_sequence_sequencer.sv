//Not use Virtual Sequence
//   drv0_seq    -------------->  env0.i_agt.sqr
//   drv1_seq    -------------->  env1.i_agt.sqr
//Use Virtual Sequence
//   drv0_seq                            env0.i_agt.sqr
//            \ v_seq ----------> v_sqr /
//            /                         \
//   drv1_seq                            env1.i_agt.sqr


/////////////////////////////
//Virtual Sequencer:
/////////////////////////////
//  -contains the pointers to real Sequencers
  class my_virtualSequencer extends uvm_sequencer;
    my_sequencer p_sqr0;
    my_sequencer p_sqr1;
  endclass

//  -instantiated and connected in base_test
  class base_test extends uvm_test;
    my_env env0;
    my_env env1;
    my_virtualSequencer v_sqr;
  endclass
  function void base_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
    env0 = my_env::type_id::create("env0", this);
    env1 = my_env::type_id::create("env1", this);
    v_sqr = my_virtualSequencer::type_id::create("v_sqr", this);
  endfunction
  function void base_test::connect_phase(uvm_phase phase);
    v_sqr.p_sqr0 = env0.i_agt.sqr;
    v_sqr.p_sqr1 = env1.i_agt.sqr;
  endfunction


/////////////////////////////
//Virtual Sequence:
/////////////////////////////
//  -does not generate transaction, so no transaction parameter is needed
//  -used to coordinate real Sequences
//  -need a Virtual Sequencer
//  -use `uvm_do_on macro
//  -Please note:
//  -m_sequencer is Sequence's member variable
//  -`uvm_declare_p_sequencer calls $cast() convert
//   m_sequencer to p_sequencer before pre_body.
//   so p_sequencer points to my_virtualSequencer

  class case0_virtualSequence extends uvm_sequence;
    `uvm_object_utils(case0_virtualSequence)
    `uvm_declare_p_sequencer(my_virtualSequencer)
    virtual task body();
      my_transaction tr;
      drv0_seq seq0;
      drv1_seq seq1;
      `uvm_do_on_with(tr, p_sequencer.p_sqr0, {tr.pload.size==1500;})
      `uvm_info("vseq", "send one longest packet on p_sequencer.p_sqr0", UVM_MEDUIM)
      fork
        `uvm_do_on(seq0, p_sequencer.p_sqr0)
        `uvm_do_on(seq1, p_sequencer.p_sqr1)
      join
    endtask
  endclass

  class drv0_seq extends uvm_sequence #(my_transaction);
    virtual task body();
      repeat (10) begin
        `uvm_do(m_trans)
        `uvm_info("drv0_seq", "send one transaction", UVM_MEDIUM)
      end
    endtask
  endclass

  class drv1_seq extends uvm_sequence #(my_transaction);
    virtual task body();
      repeat (10) begin
        `uvm_do(m_trans)
        `uvm_info("drv1_seq", "send one transaction", UVM_MEDIUM)
      end
    endtask
  endclass


