class apb_driver extends uvm_driver #(apb_xtn);

	`uvm_component_utils(apb_driver)

	virtual ahb2apb_if.apb_drv_mp vif;
	
	apb_agent_config m_cfg;

	extern function new(string name = "apb_driver", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(apb_xtn xtn);
	extern function void report_phase(uvm_phase phase);

endclass

//constructor
function apb_driver::new(string name = "apb_driver", uvm_component parent);
	super.new(name, parent);
endfunction

//report pahse
function void apb_driver::report_phase(uvm_phase phase);
	`uvm_info(get_type_name(), $sformatf("Report : APB driver send %0d transactions", m_cfg.drv_data_count), UVM_LOW)
endfunction

//connect phase
function void apb_driver::connect_phase(uvm_phase phase);
	vif = m_cfg.vif;
endfunction

//run phase
task apb_driver::run_phase(uvm_phase phase);
	forever
		begin
			seq_item_port.get_next_item(req);
			send_to_dut(req);
			seq_item_port.item_done();
		end
endtask

//send to dut
task apb_driver::send_to_dut(apb_xtn xtn);
	begin
		`uvm_info("APB_DRIVER", $sformatf("printing from driver \n %s", xtn.sprint()), UVM_LOW)
		wait(vif.apb_drv_cb.Pselx != 0)
		if(!vif.apb_drv_cb.Pwrite)
			vif.apb_drv_cb.Prdata <= {$random};
		repeat(2) @(vif.apb_drv_cb);
		wait(vif.apb_drv_cb.Penable)
		m_cfg.drv_data_count++;
	end
endtask

//build phase
function void apb_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(apb_agent_config)::get(this, "", "apb_agent_config", m_cfg))
		`uvm_fatal("CONFIG", "cannot get m_cfg")
endfunction
