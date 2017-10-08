///////////////////////////////////////////////////////////////////
//-- one sequencer can take different types of transactions
///////////////////////////////////////////////////////////////////

//1. Sequencer and Driver take uvm_sequence_item as parameter
   class my_sequencer extends uvm_sequencer #(uvm_sequence_item);
   class my_driver extends uvm_driver #(uvm_sequence_item);

//2. Sequence generates two different types of transactions
   class case0_sequence extends uvm_sequence;
     my_transaction   m_trans;
     your_transaction y_trans;
     virtual task body();
        repeat (10) begin
          `uvm_do(m_trans)
          `uvm_do(y_trans)
        end
     endtask
     `uvm_object_utils(case0_sequence)
   endclass

//3. Driver use $cast()
   task my_driver::main_phase(uvm_phase phase);
     my_transaction   m_tr;
     your_transaction y_tr;
     while (1) begin
       seq_item_port.get_next_item(req);
       if ($cast(m_tr, req)) begin
         drive_my_transaction(m_tr);
         `uvm_info("driver", "receive my_transaction", UVM_MEDIUM)
       end
       else if ($cast(y_tr, req)) begin
         drive_your_transaction(y_tr);
         `uvm_info("driver", "receive your_transaction", UVM_MEDIUM)
       end
       else begin
         `uvm_error("driver", "receive an unknown type of transaction")
       end
       seq_item_port.item_done();
     end
   endtask




