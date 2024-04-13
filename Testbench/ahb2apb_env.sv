class ahb2apb_env extends uvm_env;

	`uvm_component_utils(ahb2apb_env)

	ahb_agent_top ahb_agt_top;
	apb_agent_top apb_agt_top;

	ahb2apb_virtual_sequencer v_sequencer;

	ahb2apb_scoreboard sb;

	ahb2apb_env_config m_cfg;

	extern function new(string name = "ahb2apb_env", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass

//constructor
function ahb2apb_env::new(string name = "ahb2apb_env", uvm_component parent);
	super.new(name, parent);
endfunction

//build phase
function void ahb2apb_env::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(ahb2apb_env_config)::get(this, "", "ahb2apb_env_config", m_cfg))
		`uvm_fatal("CONFIG", "cannot get m_cfg")
	if(m_cfg.has_ahb_agent)
		begin
			ahb_agt_top = ahb_agent_top::type_id::create("ahb_agt_top", this);	
		end
	if(m_cfg.has_apb_agent)
		begin
			apb_agt_top = apb_agent_top::type_id::create("apb_agt_top", this);
		end
	if(m_cfg.has_virtual_sequencer)
		begin
			v_sequencer = ahb2apb_virtual_sequencer::type_id::create("v_sequencer", this);
		end
	if(m_cfg.has_scoreboard)
		begin
			sb = ahb2apb_scoreboard::type_id::create("sb", this);
		end
endfunction

//connect phase
function void ahb2apb_env::connect_phase(uvm_phase phase);
	if(m_cfg.has_virtual_sequencer)
		begin
			if(m_cfg.has_ahb_agent)
				begin
					for(int i=0; i<m_cfg.no_of_ahb_agent; i++)
						begin
							v_sequencer.ahb_seqrh[i] = ahb_agt_top.agnth[i].m_sequencer;
						end
				end
			if(m_cfg.has_apb_agent)
				begin
					for(int i=0; i<m_cfg.no_of_apb_agent; i++)
						begin
							v_sequencer.apb_seqrh[i] = apb_agt_top.agnth[i].m_sequencer;
						end
				end
		end
	if(m_cfg.has_scoreboard)
		begin
			if(m_cfg.has_ahb_agent)
				begin
					foreach(m_cfg.ahb_agt_cfg[i])
						begin
							ahb_agt_top.agnth[i].monh.monitor_port.connect(sb.fifo_ahb[i].analysis_export);
						end
				end
			if(m_cfg.has_apb_agent)
				begin
					foreach(m_cfg.apb_agt_cfg[i])
						begin
							apb_agt_top.agnth[i].monh.monitor_port.connect(sb.fifo_apb[i].analysis_export);
						end
				end
		end
endfunction
