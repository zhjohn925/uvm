// One sequencer can start many sequences
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
