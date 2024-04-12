class ahb_seq extends uvm_sequence #(ahb_xtn);

	`uvm_object_utils(ahb_seq)

	bit [31:0] haddr;
	bit hwrite;
	bit [2:0] hsize;
	bit [2:0] hburst;

	extern function new(string name = "ahb_seq");

endclass

//constructor
function ahb_seq::new(string name = "ahb_seq");
	super.new(name);
endfunction

//single transfer
class single_seq extends ahb_seq;

	`uvm_object_utils(single_seq)

	extern function new(string name = "single_seq");
	extern task body(); 

endclass

//constructor
function single_seq::new(string name = "single_seq");
	super.new(name);
endfunction

//body
task single_seq::body();
	repeat(15)
		begin
			req = ahb_xtn::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {Htrans == 2'b10 && Hburst == 3'd0;});
			finish_item(req);
		end
	haddr = req.Haddr;
	hsize = req.Hsize;
	hburst = req.Hburst;
	hwrite = req.Hwrite;

	if(hburst == 3'd1)
		begin
			for(int i=0; i<req.length-1; i++)
				begin
					start_item(req);
					if(hsize == 0)
						assert(req.randomize() with {Hsize == hsize; Hburst == hburst; Hwrite == hwrite; Htrans == 2'b11; Haddr == haddr + 1'b1;})
					if(hsize == 1)
						assert(req.randomize() with {Hsize == hsize; Hburst == hburst; Hwrite == hwrite; Htrans == 2'b11; Haddr == haddr + 2'b10;})
					if(hsize == 2)
						assert(req.randomize() with {Hsize == hsize; Hburst == hburst; Hwrite == hwrite; Htrans == 2'b11; Haddr == haddr + 3'b100;})
					finish_item(req);
					haddr = req.Haddr;
				end
		end
	start_item(req);
	assert(req.randomize() with {Htrans == 2'b00;})
	finish_item(req);
endtask

class burst_seq extends ahb_seq;

	`uvm_object_utils(burst_seq);

	extern function new(string name = "burst_seq");
	extern task body();
endclass

function burst_seq::new(string name = "burst_seq");
	super.new(name);
endfunction

task burst_seq::body();
	repeat(10)
		begin
			req = ahb_xtn::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {Htrans == 2'b10 && Hburst inside {[1:7]};})
			finish_item(req);

			haddr = req.Haddr;
			hsize = req.Hsize;
			hburst = req.Hburst;
			hwrite = req.Hwrite;

			if(hburst == 3'b011)
				begin
					for(int i=0; i<3; i++)
						begin
							start_item(req);
							if(hsize == 0)
								assert(req.randomize() with {Hsize == hsize; Hburst == hburst; Hwrite == hwrite; Htrans == 2'b11; Haddr == haddr + 1'b1;})
							if(hsize == 1)
								assert(req.randomize() with {Hsize == hsize; Hburst == hburst; Hwrite == hwrite; Htrans == 2'b11; Haddr == haddr + 2'b10;})
							if(hsize == 2)
								assert(req.randomize() with {Hsize == hsize; Hburst == hburst; Hwrite == hwrite; Htrans == 2'b11; Haddr == haddr + 3'b100;})
							finish_item(req);
							haddr = req.Haddr;
						end 
				end
			if(hburst == 3'b101)
				begin
					for(int i=0; i<7; i++)
						begin
							start_item(req);
							if(hsize == 0)
								assert(req.randomize() with {Hsize == hsize; Hburst == hburst; Hwrite == hwrite; Htrans == 2'b11; Haddr == haddr + 1'b1;})
							if(hsize == 1)
								assert(req.randomize() with {Hsize == hsize; Hburst == hburst; Hwrite == hwrite; Htrans == 2'b11; Haddr == haddr + 2'b10;})
							if(hsize == 2)
								assert(req.randomize() with {Hsize == hsize; Hburst == hburst; Hwrite == hwrite; Htrans == 2'b11; Haddr == haddr + 3'b100;})
							finish_item(req);
							haddr = req.Haddr;
						end 
				end
			if(hburst == 3'b111)
				begin
					for(int i=0; i<15; i++)
						begin
							start_item(req);
							if(hsize == 0)
								assert(req.randomize() with {Hsize == hsize; Hburst == hburst; Hwrite == hwrite; Htrans == 2'b11; Haddr == haddr + 1'b1;})
							if(hsize == 1)
								assert(req.randomize() with {Hsize == hsize; Hburst == hburst; Hwrite == hwrite; Htrans == 2'b11; Haddr == haddr + 2'b10;})
							if(hsize == 2)
								assert(req.randomize() with {Hsize == hsize; Hburst == hburst; Hwrite == hwrite; Htrans == 2'b11; Haddr == haddr + 3'b100;})
							finish_item(req);
							haddr = req.Haddr;
						end 
				end
			if(hburst == 3'b001)
				begin
					for(int i=0; i<req.length-1; i++)
						begin
							start_item(req);
							if(hsize == 0)
								assert(req.randomize() with {Hsize == hsize; Hburst == hburst; Hwrite == hwrite; Htrans == 2'b11; Haddr == haddr + 1'b1;})
							if(hsize == 1)
								assert(req.randomize() with {Hsize == hsize; Hburst == hburst; Hwrite == hwrite; Htrans == 2'b11; Haddr == haddr + 2'b10;})
							if(hsize == 2)
								assert(req.randomize() with {Hsize == hsize; Hburst == hburst; Hwrite == hwrite; Htrans == 2'b11; Haddr == haddr + 3'b100;})
							finish_item(req);
							haddr = req.Haddr;
						end 
				end
			if(hburst == 3'b010)
				begin
					for(int i=0; i<3; i++)
						begin
							start_item(req);
							if(hsize == 0)
								assert(req.randomize() with {Hsize == hsize; Hburst == hburst; Hwrite == hwrite; Htrans == 2'b11; Haddr == {haddr[31:2], haddr[1:0] + 1'b1};})
							if(hsize == 1)
								assert(req.randomize() with {Hsize == hsize; Hburst == hburst; Hwrite == hwrite; Htrans == 2'b11; Haddr == {haddr[31:3], haddr[2:1] + 1'b1, haddr[0]};})
							if(hsize == 2)
								assert(req.randomize() with {Hsize == hsize; Hburst == hburst; Hwrite == hwrite; Htrans == 2'b11; Haddr == {haddr[31:4], haddr[3:2] + 1'b1, haddr[1:0]};})
							finish_item(req);
							haddr = req.Haddr;
						end 
				end
			if(hburst == 3'b100)
				begin
					for(int i=0; i<7; i++)
						begin
							start_item(req);
							if(hsize == 0)
								assert(req.randomize() with {Hsize == hsize; Hburst == hburst; Hwrite == hwrite; Htrans == 2'b11; Haddr == {haddr[31:3], haddr[2:0] + 1'b1};})
							if(hsize == 1)
								assert(req.randomize() with {Hsize == hsize; Hburst == hburst; Hwrite == hwrite; Htrans == 2'b11; Haddr == {haddr[31:4], haddr[3:1] + 1'b1, haddr[0]};})
							if(hsize == 2)
								assert(req.randomize() with {Hsize == hsize; Hburst == hburst; Hwrite == hwrite; Htrans == 2'b11; Haddr == {haddr[31:5], haddr[4:2] + 1'b1, haddr[1:0]};})
							finish_item(req);
							haddr = req.Haddr;
						end 
				end
			if(hburst == 3'b110)
				begin
					for(int i=0; i<15; i++)
						begin
							start_item(req);
							if(hsize == 0)
								assert(req.randomize() with {Hsize == hsize; Hburst == hburst; Hwrite == hwrite; Htrans == 2'b11; Haddr == {haddr[31:4], haddr[3:0] + 1'b1};})
							if(hsize == 1)
								assert(req.randomize() with {Hsize == hsize; Hburst == hburst; Hwrite == hwrite; Htrans == 2'b11; Haddr == {haddr[31:5], haddr[4:1] + 1'b1, haddr[0]};})
							if(hsize == 2)
								assert(req.randomize() with {Hsize == hsize; Hburst == hburst; Hwrite == hwrite; Htrans == 2'b11; Haddr == {haddr[31:6], haddr[5:2] + 1'b1, haddr[1:0]};})
							finish_item(req);
							haddr = req.Haddr;
						end 
				end
		end

	start_item(req);
	assert(req.randomize() with {Htrans == 2'b00;})
	finish_item(req);
endtask

