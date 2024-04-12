class ahb_monitor extends uvm_monitor;

	`uvm_component_utils(ahb_monitor)

	virtual ahb2apb_if.ahb_mon_mp vif;

	ahb_agent_config m_cfg;

	uvm_analysis_port #(ahb_xtn) monitor_port;

	extern function new(string name = "ahb_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
	extern function void report_phase(uvm_phase phase);

endclass

//constructor
function ahb_monitor::new(string name = "ahb_monitor", uvm_component parent);
	super.new(name, parent);
	monitor_port = new("monitor_port", this);
endfunction

//collect data
task ahb_monitor::collect_data();
	ahb_xtn mon_data;
	begin
		mon_data = ahb_xtn::type_id::create("mon_data");
		wait(vif.ahb_mon_cb.Htrans == 2'b10 || vif.ahb_mon_cb.Htrans == 2'b11)
		mon_data.Haddr = vif.ahb_mon_cb.Haddr;
		mon_data.Htrans = vif.ahb_mon_cb.Htrans;
		mon_data.Hwrite = vif.ahb_mon_cb.Hwrite;
		mon_data.Hsize = vif.ahb_mon_cb.Hsize;
		@(vif.ahb_mon_cb);
		wait(vif.ahb_mon_cb.Hreadyout)
		if(vif.ahb_mon_cb.Hwrite)
			mon_data.Hwdata = vif.ahb_mon_cb.Hwdata;
		else
			mon_data.Hrdata = vif.ahb_mon_cb.Hrdata;
		m_cfg.mon_data_count++;
		`uvm_info("ROUTER_WR_MONITOR", $sformatf("printing from monitor \n %s", mon_data.sprint()), UVM_LOW)
		monitor_port.write(mon_data);
	end
endtask

//report phase
function void ahb_monitor::report_phase(uvm_phase phase);
	`uvm_info(get_type_name(), $sformatf("Report : AHB monitor collected transactions %0d ", m_cfg.mon_data_count), UVM_LOW)
endfunction

//build phase
function void ahb_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(ahb_agent_config)::get(this, "", "ahb_agent_config", m_cfg)) 
		`uvm_fatal("CONFIG", "cannot get m_cfg")
endfunction

//connect phase
function void ahb_monitor::connect_phase(uvm_phase phase);
	vif = m_cfg.vif;
endfunction

//run phase
task ahb_monitor::run_phase(uvm_phase phase);
	forever
		collect_data();
endtask
