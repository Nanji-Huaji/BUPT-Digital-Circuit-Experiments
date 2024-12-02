module four_adder(a,b,s,ci,cout);
	input [3:0] a;
	input [3:0] b;
	input ci;
	output [3:0] s;
	output cout;
	wire c1,c2,c3;
	adder u0(.a(a[0]),.b(b[0]),.ci_1(ci),.si(s[0]),.ci(c1));
	adder u1(.a(a[1]),.b(b[1]),.ci_1(c1),.si(s[1]),.ci(c2));
	adder u2(.a(a[2]),.b(b[2]),.ci_1(c2),.si(s[2]),.ci(c3));
	adder u3(.a(a[3]),.b(b[3]),.ci_1(c3),.si(s[3]),.ci(cout));
endmodule