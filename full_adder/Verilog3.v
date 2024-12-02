module adder(a,b,ci_1,si,ci);
	input a,b,ci_1;
	output si,ci;
	assign{ci,si}=a+b+ci_1;
endmodule