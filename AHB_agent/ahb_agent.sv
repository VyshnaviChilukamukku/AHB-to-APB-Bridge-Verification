class ahb_agent extends uvm_agent;

	`uvm_component_utils(ahb_agent)

	ahb_agent_config m_cfg;

	ahb_monitor monh;
	ahb_driver drvh;
	ahb_sequencer m_sequencer;

	extern function new(string name = "ahb_agent", uvm_component parent = null);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass

//build phase
function void ahb_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(ahb_agent_config)::get(this, "", "ahb_agent_config", m_cfg))
		`uvm_fatal("CONFIG", "cannot get m_cfg")
	monh = ahb_monitor::type_id::create("monh", this);
	if(m_cfg.is_active == UVM_ACTIVE)
		begin
			drvh = ahb_driver::type_id::create("drvh", this);
			m_sequencer = ahb_sequencer::type_id::create("m_sequencer", this);
		end
endfunction

//connect phase
function void ahb_agent::connect_phase(uvm_phase phase);
	if(m_cfg.is_active == UVM_ACTIVE)
		begin
			drvh.seq_item_port.connect(m_sequencer.seq_item_export);
		end
endfunction

//constructor
function ahb_agent::new(string name = "ahb_agent", uvm_component parent = null);
	super.new(name, parent);
endfunction
