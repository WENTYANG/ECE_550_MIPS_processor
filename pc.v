module pc(clk, rst, pc_in, pc_out);
	input clk, rst;
	input [31:0] pc_in;
	output [31:0] pc_out;
	
	//Internal wire
	wire rst;
	
	//Register
	reg [31:0] pc_out;
	
	//Initialize pc_out to 0
	initial begin
		pc_out = 32'd0;
	end
	
	//Set value of pc_out on positive edge of the clock or reset
	always @(posedge clk or posedge rst) begin
		if(rst) begin
				pc_out <= 32'd0;
		end else begin
			pc_out <= pc_in;
		end
	end
endmodule
