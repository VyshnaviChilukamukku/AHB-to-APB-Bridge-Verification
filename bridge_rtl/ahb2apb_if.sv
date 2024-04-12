interface ahb2apb_if(input bit clock);

	logic Hresetn;
	logic Hwrite;
	logic [2:0] Hsize;
	logic [1:0] Htrans;
	logic [31:0] Hwdata;
	logic Hreadyin;
	logic [31:0] Haddr;
	logic [2:0] Hburst;
	logic [31:0] Prdata;

	logic Penable;
	logic Pwrite;
	logic [31:0] Pwdata;
	logic [31:0] Paddr;
	logic Hreadyout;
	logic [2:0] Pselx;
	logic [31:0] Hrdata;
	logic [1:0] Hresp;

	clocking ahb_drv_cb @(posedge clock);
		default input #1 output #1;
		output Hwdata;
		output Haddr;
		output Hwrite;
		output Hresetn;
		output Hreadyin;
		input  Hreadyout;
		output Hsize;
		output Htrans;
		output Hburst;
		input Hrdata;
	endclocking

	clocking ahb_mon_cb @(posedge clock);
		default input #1 output #1;
		input Hwdata;
		input Haddr;
		input Hwrite;
		input Hresetn;
		input Hreadyin;
		input Hreadyout;
		input Hsize;
		input Htrans;
		input Hburst;
		input Hrdata;
	endclocking

	clocking apb_drv_cb @(posedge clock);
		default input #1 output #1;
		output Prdata;
		input Pwrite;
		input Penable;
		input Pselx;
	endclocking

	clocking apb_mon_cb @(posedge clock);
		default input #1 output #1;
		input Prdata;
		input Pwrite;
		input Penable;
		input Pwdata;
		input Paddr;
		input Pselx;
	endclocking

	modport ahb_drv_mp(clocking ahb_drv_cb);
	modport ahb_mon_mp(clocking ahb_mon_cb);
	modport apb_drv_mp(clocking apb_drv_cb);
	modport apb_mon_mp(clocking apb_mon_cb);

endinterface
