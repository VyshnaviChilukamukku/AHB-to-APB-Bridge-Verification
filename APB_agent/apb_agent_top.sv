class apb_agent_top extends uvm_env;

	`uvm_component_utils(apb_agent_top)

	apb_agent agnth[];
	ahb2apb_env_config m_cfg;
	
	extern function new(string name = "apb_agent_top", uvm_component parent);
	extern function void build_phase(uvm_phase phase);

endclass

//constructor
function apb_agent_top::new(string name = "apb_agent_top", uvm_component parent);
	super.new(name, parent);
endfunction

//build phase
function void apb_agent_top::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(ahb2apb_env_config)::get(this, "", "ahb2apb_env_config", m_cfg))
		`uvm_fatal("get_type_name()", "ENV : write error")
	agnth = new[m_cfg.no_of_apb_agent];
	foreach(agnth[i])
		begin
			agnth[i] = apb_agent::type_id::create($sformatf("agnth[%0d]", i), this);
			uvm_config_db #(apb_agent_config)::set(this, $sformatf("agnth[%0d]*", i), "apb_agent_config", m_cfg.apb_agt_cfg[i]);
		end
endfunction
