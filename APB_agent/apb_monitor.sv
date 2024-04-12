class apb_monitor extends uvm_monitor;

	`uvm_component_utils(apb_monitor)

	virtual ahb2apb_if.apb_mon_cb vif;

	apb_agent_config m_cfg;

	uvm_analysis_port #(apb_xtn) monitor_port;

	extern function new(string name = "apb_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
	extern function void report_phase(uvm_phase phase);

endclass

//constructor
function apb_monitor::new(string name = "apb_monitor", uvm_component parent);
	super.new(name, parent);
	monitor_port = new("monitor_port", this);
endfunction

//build phase
function void apb_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(apb_agent_config)::get(this, "", "apb_agent_config", m_cfg))
		`uvm_fatal("CONFIG", "cannot get cfg")
endfunction

//connect phase
function void apb_monitor::connect_phase(uvm_phase phase);
	vif = m_cfg.vif;
endfunction

//run phase
task apb_monitor::run_phase(uvm_phase phase);
	forever
		begin
			collect_data();
		end
endtask

//collect data
task apb_monitor::collect_data();
	apb_xtn mon_data;
	mon_data = apb_xtn::type_id::create("mon_data");
	wait(vif.apb_mon_cb.Penable)
	mon_data.Paddr = vif.apb_mon_cb.Paddr;
	mon_data.Pwrite = vif.apb_mon_cb.Pwrite;
	mon_data.Pselx = vif.apb_mon_cb.Pselx;
	if(mon_data.Pwrite)
		mon_data.Pwdata = vif.apb_mon_cb.Pwdata;
	else
		mon_data.Prdata = vif.apb_mon_cb.Prdata;
	@(vif.apb_mon_cb);
	`uvm_info("ROUTER_RD_MONITOR", $sformatf("printing from monitor \n %s", mon_data.sprint()), UVM_LOW)
	m_cfg.mon_data_count++;
	monitor_port.write(mon_data); 
endtask

//report phase
function void apb_monitor::report_phase(uvm_phase phase);
	`uvm_info(get_type_name(), $sformatf("Report : APB monitor send %0d transactions", m_cfg.mon_data_count), UVM_LOW)
endfunction
