class ahb2apb_env_config extends uvm_object;
	
	bit has_ahb_agent = 1;
	bit has_apb_agent = 1;
	bit has_virtual_sequencer = 1;
	bit has_scoreboard = 1;
	int no_of_ahb_agent = 1;
	int no_of_apb_agent = 1;
 
	ahb_agent_config ahb_agt_cfg[];
	apb_agent_config apb_agt_cfg[];

	`uvm_object_utils(ahb2apb_env_config)

	extern function new(string name = "ahb2apb_env_config");

endclass

//constructor
function ahb2apb_env_config::new(string name = "ahb2apb_env_config");
	super.new(name);
endfunction
