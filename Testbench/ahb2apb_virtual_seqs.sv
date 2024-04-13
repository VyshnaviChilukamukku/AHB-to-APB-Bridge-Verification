
class ahb2apb_vbase_seq extends uvm_sequence #(uvm_sequence_item);

	`uvm_object_utils(ahb2apb_vbase_seq)

	ahb_sequencer ahb_seqrh[];
	apb_sequencer apb_seqrh[];

	ahb2apb_virtual_sequencer vsqrh;

	ahb2apb_env_config m_cfg;

	extern function new(string name = "ahb2apb_vbase_seq");
	extern task body();

endclass

//constructor 
function ahb2apb_vbase_seq::new(string name = "ahb2apb_vbase_seq");
	super.new(name);
endfunction

//run phase
task ahb2apb_vbase_seq::body();
	if(!uvm_config_db #(ahb2apb_env_config)::get(null, get_full_name(), "ahb2apb_env_config", m_cfg))
		`uvm_fatal("get_type_name()", "cannot get cfg")
	ahb_seqrh = new[m_cfg.no_of_ahb_agent];
	apb_seqrh = new[m_cfg.no_of_apb_agent];

	assert($cast(vsqrh, m_sequencer))
	else
		begin
			`uvm_error("BODY", "error in $cast")
		end
	foreach(ahb_seqrh[i])
		ahb_seqrh[i] = vsqrh.ahb_seqrh[i];
	foreach(apb_seqrh[i])
		apb_seqrh[i] = vsqrh.apb_seqrh[i];
endtask

//single transfer
class single_vseq extends ahb2apb_vbase_seq;

	`uvm_object_utils(single_vseq)

	single_seq ss;

	extern function new(string name = "single_vseq");
	extern task body();

endclass

//constructor
function single_vseq::new(string name = "single_vseq");
	super.new(name);
endfunction

//body
task single_vseq::body();
	super.body();
	if(m_cfg.has_ahb_agent)
		begin
			ss = single_seq::type_id::create("ss");
			ss.start(ahb_seqrh[0]);
		end
endtask

//burst transfer
class burst_vseq extends ahb2apb_vbase_seq;

	`uvm_object_utils(burst_vseq)

	burst_seq bs;

	extern function new(string name = "burst_vseq");
	extern task body();

endclass

//constructor
function burst_vseq::new(string name = "burst_vseq");
	super.new(name);
endfunction

//body
task burst_vseq::body();
	super.body();
	if(m_cfg.has_ahb_agent)
		begin
			bs = burst_seq::type_id::create("bs");
			bs.start(ahb_seqrh[0]);
		end
endtask


