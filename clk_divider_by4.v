module clk_divider_by4 (clk,rst, out_clk);
 
input clk;
input rst;
output out_clk;
 
reg [1:0] r_reg;
wire [1:0] r_nxt;
reg clk_track;
 
always @(posedge clk or posedge rst)
 
begin
  if (rst)
     begin
        r_reg <= 3'b0;
	clk_track <= 1'b0;
     end
 
  else if (r_nxt == 2'b10)
 	   begin
	     r_reg <= 0;
	     clk_track <= ~clk_track;
	   end
 
  else 
      r_reg <= r_nxt;
end
 
 assign r_nxt = r_reg+1;   	      
 assign out_clk = clk_track;
endmodule