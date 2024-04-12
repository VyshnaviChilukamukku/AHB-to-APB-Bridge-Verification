class apb_agent_config extends uvm_object;
	
	`uvm_object_utils(apb_agent_config)

	virtual ahb2apb_if vif;
	
	static int drv_data_count = 0;
	static int mon_data_count = 0;
	
	uvm_active_passive_enum is_active = UVM_ACTIVE;

	extern function new(string name = "apb_agent_config");

endclass

//constructor
function apb_agent_config::new(string name = "apb_agent_config");
	super.new(name);
endfunction
