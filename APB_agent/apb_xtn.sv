class apb_xtn extends uvm_sequence_item;

	`uvm_object_utils(apb_xtn)

	bit [31:0] Paddr;
	bit [31:0] Pwdata;
	rand bit [31:0] Prdata;
	bit [31:0] Pselx;
	bit Penable;
	bit Pwrite;
	
	extern function new(string name = "apb_xtn");
	extern function void do_print(uvm_printer printer);

endclass

//constructor
function apb_xtn::new(string name = "apb_xtn");
	super.new(name);
endfunction

//do print
function void apb_xtn::do_print(uvm_printer printer);
	super.do_print(printer);
	printer.print_field("Paddr", this.Paddr, 32, UVM_HEX);
        printer.print_field("Penable", this.Penable, 1, UVM_DEC);
        printer.print_field("Pwrite", this.Pwrite, 1, UVM_DEC);
        printer.print_field("Pselx", this.Pselx, 4, UVM_DEC);
        printer.print_field("Prdata", this.Prdata, 32, UVM_HEX);
	printer.print_field("Pwdata", this.Pwdata, 32, UVM_HEX);
endfunction
