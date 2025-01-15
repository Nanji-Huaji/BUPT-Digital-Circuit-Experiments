module dff_sync ( 
input clk, rst_n, 
input d, 
output reg q 
); 
always@(posedge clk) begin  //复位 
if(!rst_n) q <= 0; 
else        
q <= d; 
end 
endmodule