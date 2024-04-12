class ahb_agent_top extends uvm_env;

	`uvm_component_utils(ahb_agent_top)

	ahb_agent agnth[];

	ahb2apb_env_config m_cfg;

	extern function new(string name = "ahb_agent_top", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass

//constructor
function ahb_agent_top::new(string name = "ahb_agent_top", uvm_component parent);
	super.new(name, parent);
endfunction

//run phase
task ahb_agent_top::run_phase(uvm_phase phase);
	uvm_top.print_topology;
endtask

//build phase
function void ahb_agent_top::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(ahb2apb_env_config)::get(this, "", "ahb2apb_env_config", m_cfg))
		`uvm_fatal(get_type_name(), "ENV : write error")
	agnth = new[m_cfg.no_of_ahb_agent];
	foreach(agnth[i])
		begin
			agnth[i] = ahb_agent::type_id::create($sformatf("agnth[%0d]", i), this);
			uvm_config_db #(ahb_agent_config)::set(this, $sformatf("agnth[%0d]*", i), "ahb_agent_config", m_cfg.ahb_agt_cfg[i]);
		end
endfunction
