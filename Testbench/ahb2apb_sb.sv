class ahb2apb_scoreboard extends uvm_scoreboard;

	`uvm_component_utils(ahb2apb_scoreboard)

	uvm_tlm_analysis_fifo #(ahb_xtn) fifo_ahb[];
	uvm_tlm_analysis_fifo #(apb_xtn) fifo_apb[];

	ahb_xtn ahb_data;
	apb_xtn apb_data;

	ahb_xtn ahb_cov_data;
	apb_xtn apb_cov_data;

	ahb2apb_env_config e_cfg;

	int data_verified_count;

	ahb_xtn q[$];

	extern function new(string name = "ahb2apb_scoreboard", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern function void check_data(apb_xtn xtn);
	extern function void compare_data(int Hdata, Pdata, Haddr, Paddr);
	extern function void report_phase(uvm_phase phase);
//coverage
	//covergroup ahb_fcov;
	//	option.per_instance = 1;
covergroup ahb_fcov;
                option.per_instance = 1;
                SIZE: coverpoint ahb_cov_data.Hsize {bins b2[] = {[0:2]} ;}
                TRANS: coverpoint ahb_cov_data.Htrans {bins trans[] = {[2:3]} ;}
                ADDR: coverpoint ahb_cov_data.Haddr {bins first_slave = {[32'h8000_0000:32'h8000_03ff]} ;
                                                     bins second_slave = {[32'h8400_0000:32'h8400_03ff]};
                                                     bins third_slave = {[32'h8800_0000:32'h8800_03ff]};
                                                     bins fourth_slave = {[32'h8C00_0000:32'h8C00_03ff]};}
                DATA_IN: coverpoint ahb_cov_data.Hwdata {bins low = {[0:32'h0000_ffff]};
                                                         bins mid1 = {[32'h0001_ffff:32'hffff_ffff]};}
                DATA_OUT : coverpoint ahb_cov_data.Hrdata {bins low = {[0:32'h0000_ffff]};
                                                           bins mid1 = {[32'h0001_ffff:32'hffff_ffff]};}
                WRITE : coverpoint ahb_cov_data.Hwrite;
                SIZEXWRITE: cross SIZE, WRITE;
        	
	endgroup

//	covergroup apb_fcov;
//		option.per_instance = 1;
covergroup apb_fcov;
                option.per_instance = 1;
                ADDR : coverpoint apb_cov_data.Paddr {bins first_slave = {[32'h8000_0000:32'h8000_03ff]};
                                                      bins second_slave = {[32'h8400_0000:32'h8400_03ff]};
                                                      bins third_slave = {[32'h8800_0000:32'h8800_03ff]};
                                                      bins fourth_slave = {[32'h8C00_0000:32'h8C00_03ff]};}

                DATA_IN : coverpoint apb_cov_data.Pwdata {bins low = {[0:32'h0000_ffff]};
                                                          bins mid1 = {[32'h0001_ffff:32'hffff_ffff]};}

                DATA_OUT : coverpoint apb_cov_data.Prdata {bins low = {[0:32'hffff_ffff]};}

                WRITE : coverpoint apb_cov_data.Pwrite;

                SEL : coverpoint apb_cov_data.Pselx {bins first_slave = {4'b0001};
                                                     bins second_slave = {4'b0010};
                                                     bins third_slave = {4'b0100};
                                                     bins fourth_slave = {4'b1000};}

                WRITEXSEL: cross WRITE, SEL;
        endgroup




endclass
//constructor
function ahb2apb_scoreboard::new(string name = "ahb2apb_scoreboard", uvm_component parent);
	super.new(name, parent);
	ahb_fcov = new();
	apb_fcov = new();
	ahb_cov_data = new();
	apb_cov_data = new();
endfunction

//build phase
function void ahb2apb_scoreboard::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(ahb2apb_env_config)::get(this, "", "ahb2apb_env_config", e_cfg))
		`uvm_fatal("EN_cfg", "no update")
	ahb_data = ahb_xtn::type_id::create("ahb_data", this);
	apb_data = apb_xtn::type_id::create("apb_data", this);

	fifo_ahb = new[e_cfg.no_of_ahb_agent];
	foreach(fifo_ahb[i])
		begin
			fifo_ahb[i] = new($sformatf("fifo_ahb[%0d]", i), this);
		end
	fifo_apb = new[e_cfg.no_of_apb_agent];
	foreach(fifo_apb[i])
		begin
			fifo_apb[i] = new($sformatf("fifo_apb[%0d]", i), this);
		end
endfunction

//run phase
task ahb2apb_scoreboard::run_phase(uvm_phase phase);
	fork
		begin
			forever
				begin
					fifo_ahb[0].get(ahb_data);
					`uvm_info("WRITE SB", "write data", UVM_LOW)
					q.push_back(ahb_data);
					ahb_cov_data = ahb_data;
					ahb_fcov.sample();
				end
		end
		begin
			forever
				begin
					fork
						begin
							fifo_apb[0].get(apb_data);
							`uvm_info("READ SB[0]", "read data", UVM_LOW)
							apb_data.print;
							check_data(apb_data);
							apb_cov_data = apb_data;
							apb_fcov.sample();
						end
					join
				end
		end
	join
endtask

//check data
function void ahb2apb_scoreboard::check_data(apb_xtn xtn);
	ahb_data = q.pop_front();
	if(ahb_data.Hwrite)
		begin
			case(ahb_data.Hsize)
				2'b00 : begin
						if(ahb_data.Haddr[1:0] == 2'b00)
							compare_data(ahb_data.Hwdata[7:0], apb_data.Pwdata[7:0], ahb_data.Haddr, apb_data.Paddr);
						if(ahb_data.Haddr[1:0] == 2'b01)
							compare_data(ahb_data.Hwdata[15:8], apb_data.Pwdata[7:0], ahb_data.Haddr, apb_data.Paddr);
						if(ahb_data.Haddr[1:0] == 2'b10)
							compare_data(ahb_data.Hwdata[23:16], apb_data.Pwdata[7:0], ahb_data.Haddr, apb_data.Paddr);
						if(ahb_data.Haddr[1:0] == 2'b11)
							compare_data(ahb_data.Hwdata[31:24], apb_data.Pwdata[7:0], ahb_data.Haddr, apb_data.Paddr);
					end
				2'b01 : begin
						if(ahb_data.Haddr[1:0] == 2'b00)
							compare_data(ahb_data.Hwdata[15:0], apb_data.Pwdata[15:0], ahb_data.Haddr, apb_data.Paddr);
						if(ahb_data.Haddr[1:0] == 2'b10)
							compare_data(ahb_data.Hwdata[31:16], apb_data.Pwdata[15:0], ahb_data.Haddr, apb_data.Paddr);
					end
				2'b10 : begin
						compare_data(ahb_data.Hwdata, apb_data.Pwdata, ahb_data.Haddr, apb_data.Paddr);
					end
			endcase
		end
	else
		begin
			case(ahb_data.Hsize)
				2'b00 : begin
						if(ahb_data.Haddr[1:0] == 2'b00)
							compare_data(ahb_data.Hrdata[7:0], apb_data.Prdata[7:0], ahb_data.Haddr, apb_data.Paddr);
						if(ahb_data.Haddr[1:0] == 2'b01)
							compare_data(ahb_data.Hrdata[7:0], apb_data.Prdata[15:8], ahb_data.Haddr, apb_data.Paddr);
						if(ahb_data.Haddr[1:0] == 2'b10)
							compare_data(ahb_data.Hrdata[7:0], apb_data.Prdata[23:16], ahb_data.Haddr, apb_data.Paddr);
						if(ahb_data.Haddr[1:0] == 2'b11)
							compare_data(ahb_data.Hrdata[7:0], apb_data.Prdata[31:24], ahb_data.Haddr, apb_data.Paddr);
					end
				2'b01 : begin
						if(ahb_data.Haddr[1:0] == 2'b00)
							compare_data(ahb_data.Hrdata[15:0], apb_data.Prdata[15:0], ahb_data.Haddr, apb_data.Paddr);
						if(ahb_data.Haddr[1:0] == 2'b10)
							compare_data(ahb_data.Hrdata[15:0], apb_data.Prdata[31:16], ahb_data.Haddr, apb_data.Paddr);
					end
				2'b10 : begin
						compare_data(ahb_data.Hrdata, apb_data.Prdata, ahb_data.Haddr, apb_data.Paddr);
					end
			endcase

		end
endfunction

//-------------------------------------------------------comparing data-------------------------------------------------//
function void ahb2apb_scoreboard::compare_data(int Hdata, Pdata, Haddr, Paddr);
	if(Hdata == Pdata)
		`uvm_info("SB", "DATA MATCHED SUCCESSFULLY", UVM_LOW)
	else
		`uvm_error("SB", "DATA MATCHING FAILED")
	if(Haddr == Paddr)
		`uvm_info("SB", "ADDR MATCHED SUCCESSFULLY", UVM_LOW)
	else
		`uvm_error("SB", "ADDR MATCHING FAILED")
	data_verified_count++;
endfunction

//report phase
function void ahb2apb_scoreboard::report_phase(uvm_phase phase);
	`uvm_info(get_type_name(), $sformatf("Report : Number of data verified in SB %0d", data_verified_count), UVM_LOW)
endfunction
