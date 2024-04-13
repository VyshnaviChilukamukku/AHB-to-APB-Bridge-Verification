class ahb2apb_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);

	`uvm_component_utils(ahb2apb_virtual_sequencer)

	ahb_sequencer ahb_seqrh[];
	apb_sequencer apb_seqrh[];

	ahb2apb_env_config m_cfg;

	extern function new(string name = "ahb2apb_virtual_sequencer", uvm_component parent);
	extern function void build_phase(uvm_phase phase);

endclass

//constructor
function ahb2apb_virtual_sequencer::new(string name = "ahb2apb_virtual_sequencer",uvm_component parent);
	super.new(name, parent);
endfunction

//build phase
function void ahb2apb_virtual_sequencer::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(ahb2apb_env_config)::get(this, "", "ahb2apb_env_config", m_cfg))
		`uvm_fatal("CONFIG", "cannot get m_cfg")
	ahb_seqrh = new[m_cfg.no_of_ahb_agent];
	apb_seqrh = new[m_cfg.no_of_ahb_agent]; 
endfunction
