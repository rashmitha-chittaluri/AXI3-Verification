
//`include"axi_inteface.sv"
//`timscale ---
module axi_top;

	//clk & rst 
	bit aclk, aresetn;

	//clock genration time, we will go with 50% duty cycle (posedge to negedge or
	//negedge to posedge we need to mataine same time)

	initial begin 
		forever #5 aclk=~aclk; //0ns aclk=0   5ns aclk=1   10ns aclk=0   15n aclk=1
	end 

	initial begin 
		aresetn=0;// slave driver in reset state 
		repeat(1)@(posedge aclk);
		aresetn=1;//slave driver in active state 
	end 

	//we will include physical inteface 
	axi_interface intf(aclk,aresetn);



	//we pointing physical interface to virtual interface config_db method 
	initial begin 
		uvm_config_db#(virtual axi_interface)::set(null,"*","vif",intf);//virtual axi_interface vif
		//we are potining memeory from physical interface to virtual interface 
		//
		//before accessing signals by using virtual interface handel, we need
		//follow steps 
		//
		//step1: point physical to virtual interfsce, 
		//
		//without point we cant abele to acess any interface signals by using
		//virtual interface handel 
	end



	//We will establich connection from assetion to interface 
	axi_assertion  asert(.aclk(aclk),.aresetn(aresetn),
		.awaddr(intf.asn_cb.awaddr),
		.awid(intf.asn_cb.awid),
		.awvalid(intf.asn_cb.awvalid),
		.awready(intf.asn_cb.awready),
		.awsize(intf.asn_cb.awsize),
		.awlen(intf.asn_cb.awlen),
		.awburst(intf.asn_cb.awburst), 
		.awprot(intf.asn_cb.awprot),
		.awlock(intf.asn_cb.awlock),
		.awcache(intf.asn_cb.awcache),
		.wdata(intf.asn_cb.wdata),
		.wstrb(intf.asn_cb.wstrb),
		.wlast(intf.asn_cb.wlast),
		.wid(intf.asn_cb.wid),
		.wvalid(intf.asn_cb.wvalid),
		.wready(intf.asn_cb.wready),
		.bid(intf.asn_cb.bid),
		.bvalid(intf.asn_cb.bvalid),
		.bready(intf.asn_cb.bready),
		.bresp(intf.asn_cb.bresp),
		.araddr(intf.asn_cb.araddr),
		.arid(intf.asn_cb.arid),
		.arvalid(intf.asn_cb.arvalid),
		.arready(intf.asn_cb.arready),
		.arlen(intf.asn_cb.arlen),
		.arsize(intf.asn_cb.arsize),
		.arburst(intf.asn_cb.arburst),
		.arlock(intf.asn_cb.arlock),
		.arprot(intf.asn_cb.arprot),
		.arcache(intf.asn_cb.arcache),
		.rdata(intf.asn_cb.rdata),
		.rid(intf.asn_cb.rid),
		.rlast(intf.asn_cb.rlast),
		.rresp(intf.asn_cb.rresp),
		.rvalid(intf.asn_cb.rvalid),
		.rready(intf.asn_cb.rready)        );



	//We will add plusargs to control out_of_order & overlaping transaction 
	bit out_of_order_en;//if 1 out_of_order supported   if 0 out_of_order disable also supports 
	bit overlaping_en;// if 1 overlaping is enabable if 0 overlaping is diable 
	//default value of bit is 0 indicates default out_of_order disable and
	//overlping disable
	initial begin 
		$value$plusargs("OUT_OF_ORDER_EN=%d",out_of_order_en);//+OUT_OF_ORDER_EN=1
		$value$plusargs("OVERLAPING_EN=%d",overlaping_en);
		$display("out_of_order_en=%d",out_of_order_en);

		uvm_config_db#(bit)::set(null,"*","a",out_of_order_en);
		uvm_config_db#(bit)::set(null,"*","b",overlaping_en);
	end


	string testname;
	//we need to include axi_test class
	initial begin 
		$value$plusargs("TESTNAME=%s",testname);
		run_test(testname);
	end

	initial begin 
	//	#200;
	//	$finish;
	end

endmodule



