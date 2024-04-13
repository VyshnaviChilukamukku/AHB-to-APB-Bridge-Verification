module top;

	import ahb2apb_pkg::*;
	import uvm_pkg::*;

	bit clock;

	initial
		begin
			forever
				#10 clock = ~clock;
		end

	ahb2apb_if in0(clock);
	ahb2apb_if in1(clock);

	rtl_top DUV(.Hclk(clock), .Hresetn(in0.Hresetn), .Htrans(in0.Htrans), .Hsize(in0.Hsize), .Hreadyin(in0.Hreadyin), .Hwdata(in0.Hwdata), .Haddr(in0.Haddr), .Hwrite(in0.Hwrite), .Prdata(in1.Prdata), .Hrdata(in0.Hrdata), .Hresp(in0.Hresp), .Hreadyout(in0.Hreadyout), .Pselx(in1.Pselx), .Pwrite(in1.Pwrite), .Penable(in1.Penable), .Paddr(in1.Paddr), .Pwdata(in1.Pwdata));

	initial
		begin
			uvm_config_db #(virtual ahb2apb_if)::set(null, "*", "vif_ahb", in0);
			uvm_config_db #(virtual ahb2apb_if)::set(null, "*", "vif_apb", in1);

			run_test();
		end

endmodule
