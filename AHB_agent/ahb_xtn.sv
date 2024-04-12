class ahb_xtn extends uvm_sequence_item;
	
	`uvm_object_utils(ahb_xtn)
	
	rand bit [31:0] Haddr;
	rand bit [31:0] Hwdata;
	rand bit [9:0] length;
	rand bit Hwrite;
	rand bit [1:0] Htrans;
	rand bit [2:0] Hsize;
	rand bit [2:0] Hburst;
	bit [31:0] Hrdata;
	bit Hresetn;
	bit Hreadyout;
	bit Hreadyin;
	bit [1:0] Hresp;
	
	constraint valid_Hsize {Hsize inside {[0:2]};}
	constraint valid_length {(2^Hsize) * length <= 1024;}
	constraint valid_con {Hsize == 1 -> Haddr%2 == 0; Hsize == 2 -> Haddr%4 == 0;}
	constraint valid_Haddr {Haddr inside {[32'h8000_0000 : 32'h8000_03ff], [32'h8400_0000 : 32'h8400_03ff], [32'h8800_0000 : 32'h8800_03ff], [32'h8C00_0000 : 32'h8C00_03ff]};}
	
	extern function new(string name = "ahb_xtn");
	extern function void do_print(uvm_printer printer);
endclass
	
function ahb_xtn::new(string name = "ahb_xtn");
	super.new(name);
endfunction

function void ahb_xtn::do_print(uvm_printer printer);
	super.do_print(printer);
	printer.print_field("Haddr", this.Haddr, 32, UVM_HEX);
        printer.print_field("Hwdata", this.Hwdata, 32, UVM_HEX);
        printer.print_field("Hwrite", this.Hwrite, 1, UVM_DEC);
        printer.print_field("Htrans", this.Htrans, 2, UVM_DEC);
	printer.print_field("Hsize", this.Hsize, 2, UVM_DEC);
	printer.print_field("Hburst", this.Hburst, 3, UVM_HEX);
	printer.print_field("Hrdata", this.Hrdata, 32, UVM_HEX);
endfunction
