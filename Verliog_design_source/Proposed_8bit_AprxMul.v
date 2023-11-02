module approx_mul_8x8(
    input wire [7:0]a,
    input wire [7:0]b,
	output wire [15:0]mymul
    );
	
	wire [8:0]pp1;
	wire [9:0]pp2;
	wire [7:0]pp3,pp4,pp5,pp6;
	wire [6:0]s1,c1;
	wire [6:0]s2,c2;
	wire [7:0]s3,c3;
	wire [9:0]s4,c4;
	wire [7:0]s5,c5;
	
	//Generation of Partial product rows
	approx_or_2X8 x1(a[1:0],b,pp1);
	approx_mul_2X8 x2(a[3:2],b,pp2);
	exact_pprow x3(a[4],b,pp3);
	exact_pprow x4(a[5],b,pp4);
	exact_pprow x5(a[6],b,pp5);
	exact_pprow x6(a[7],b,pp6);

	//Ripple carry addition of generated PP rows	
	
//.................stage1......................
FA f1(pp3[2],pp4[1],pp5[0],s1[0],c1[0]);
FA f2(pp3[3],pp4[2],pp5[1],s1[1],c1[1]);
FA f3(pp3[4],pp4[3],pp5[2],s1[2],c1[2]);
FA f4(pp3[5],pp4[4],pp5[3],s1[3],c1[3]);
FA f5(pp3[6],pp4[5],pp5[4],s1[4],c1[4]);
FA f6(pp3[7],pp4[6],pp5[5],s1[5],c1[5]);
FA f7(pp4[7],pp5[6],pp6[5],s1[6],c1[6]);

//.................stage2......................
FA f8(pp3[1],pp4[0],pp1[5],s2[0],c2[0]);
FA f9(pp1[7],pp6[0],s1[1],s2[1],c2[1]);
FA f10(pp1[8],pp6[1],s1[2],s2[2],c2[2]);

FA f11(pp6[2],s1[3],c1[2],s2[3],c2[3]);
FA f12(pp6[3],s1[4],c1[3],s2[4],c2[4]);
FA f13(pp6[4],s1[5],c1[4],s2[5],c2[5]);

FA f14(pp5[7],pp6[6],c1[6],s2[6],c2[6]);


//.................stage3......................
FA f15(pp3[0],pp1[4],pp2[2],s3[0],c3[0]);

FA f16(s1[0],c2[0],pp1[6],s3[1],c3[1]);

FA f17(c1[0],s2[1],pp2[5],s3[2],c3[2]);

FA f18(c1[1],s2[2],c2[1],s3[3],c3[3]);

FA f19(s2[3],c2[2],pp2[7],s3[4],c3[4]);
FA f20(s2[4],c2[3],pp2[8],s3[5],c3[5]);
FA f21(s2[5],c2[4],pp2[9],s3[6],c3[6]);

FA f22(s1[6],c1[5],c2[5],s3[7],c3[7]);


//.................stage4......................

FA f23(pp2[3],s2[0],c3[0],s4[0],c4[0]);
FA f24(pp2[4],s3[1],c4[0],s4[1],c4[1]);
FA f25(s3[2],c3[1],c4[1],s4[2],c4[2]);

FA f26(pp2[6],s3[3],c3[2],s4[3],c4[3]);
FA f27(s3[4],c3[3],c4[3],s4[4],c4[4]);
FA f28(s3[5],c3[4],c4[4],s4[5],c4[5]);
FA f29(s3[6],c3[5],c4[5],s4[6],c4[6]);
FA f30(s3[7],c3[6],c4[6],s4[7],c4[7]);

FA f31(s2[6],c3[7],c4[7],s4[8],c4[8]);
FA f32(c2[6],pp6[7],c4[8],s4[9],c4[9]);


//.................stage5......................

assign mymul[1:0]=pp1[1:0];
or o1(mymul[2],pp1[2],pp2[0]);
or o2(mymul[3],pp1[3],pp2[1]);
assign mymul[4]=s3[0];
assign mymul[7:5]=s4[2:0];

HA h1(s4[3],c4[2],s5[0],c5[0]);
HA h2(s4[4],c5[0],s5[1],c5[1]);
HA h3(s4[5],c5[1],s5[2],c5[2]);
HA h4(s4[6],c5[2],s5[3],c5[3]);
HA h5(s4[7],c5[3],s5[4],c5[4]);
HA h6(s4[8],c5[4],s5[5],c5[5]);
HA h7(s4[9],c5[5],s5[6],c5[6]);
HA h8(c4[9],c5[6],s5[7],c5[7]);

assign mymul[15:8]=s5[7:0];
//...................................

endmodule

module approx_or_2X8(
    input wire [1:0]a,
    input wire [7:0]b,
	output wire [8:0]myadder
    );
	
	wire [7:0]a0b,a1b;
	wire [8:0]p;
	
	and and0(a0b[0],a[0],b[0]);
	and and1(a0b[1],a[0],b[1]);
	and and2(a0b[2],a[0],b[2]);
	and and3(a0b[3],a[0],b[3]);
	and and4(a0b[4],a[0],b[4]);
	and and5(a0b[5],a[0],b[5]);
	and and6(a0b[6],a[0],b[6]);
	and and7(a0b[7],a[0],b[7]);

	and and8(a1b[0],a[1],b[0]);
	and and9(a1b[1],a[1],b[1]);
	and and10(a1b[2],a[1],b[2]);
	and and11(a1b[3],a[1],b[3]);
	and and12(a1b[4],a[1],b[4]);
	and and13(a1b[5],a[1],b[5]);
	and and14(a1b[6],a[1],b[6]);
	and and15(a1b[7],a[1],b[7]);
	
	assign p[0] = a0b[0];
	or or1(p[1],a0b[1],a1b[0]);
	or or2(p[2],a0b[2],a1b[1]);
	or or3(p[3],a0b[3],a1b[2]);
	or or4(p[4],a0b[4],a1b[3]);
	or or5(p[5],a0b[5],a1b[4]);
	or or6(p[6],a0b[6],a1b[5]);
	or or7(p[7],a0b[7],a1b[6]);	
	assign p[8] = a1b[7];
	
	assign myadder[8:0]=p[8:0];
	
endmodule

module approx_mul_2X8(
    input wire [1:0]a,
    input wire [7:0]b,
	output wire [9:0]myadder
    );
	
	wire [7:0]a0b,a1b;
	wire [8:0]p,pbar;
	wire [7:1]g;
	wire [9:1]c,ov;
	wire w,cd,cdbar;
	wire [9:0]w1,w2;
	
	and and0(a0b[0],a[0],b[0]);
	and and1(a0b[1],a[0],b[1]);
	and and2(a0b[2],a[0],b[2]);
	and and3(a0b[3],a[0],b[3]);
	and and4(a0b[4],a[0],b[4]);
	and and5(a0b[5],a[0],b[5]);
	and and6(a0b[6],a[0],b[6]);
	and and7(a0b[7],a[0],b[7]);

	and and8(a1b[0],a[1],b[0]);
	and and9(a1b[1],a[1],b[1]);
	and and10(a1b[2],a[1],b[2]);
	and and11(a1b[3],a[1],b[3]);
	and and12(a1b[4],a[1],b[4]);
	and and13(a1b[5],a[1],b[5]);
	and and14(a1b[6],a[1],b[6]);
	and and15(a1b[7],a[1],b[7]);
	
	assign p[0] = a0b[0];
	or or1(p[1],a0b[1],a1b[0]);
	or or2(p[2],a0b[2],a1b[1]);
	or or3(p[3],a0b[3],a1b[2]);
	or or4(p[4],a0b[4],a1b[3]);
	or or5(p[5],a0b[5],a1b[4]);
	or or6(p[6],a0b[6],a1b[5]);
	or or7(p[7],a0b[7],a1b[6]);	
	assign p[8] = a1b[7];
	
	//assign g[0] = 1'b0;
	and and16(g[1],a0b[1],a1b[0]);
	and and17(g[2],a0b[2],a1b[1]);
	and and18(g[3],a0b[3],a1b[2]);
	and and19(g[4],a0b[4],a1b[3]);
	and and20(g[5],a0b[5],a1b[4]);
	and and21(g[6],a0b[6],a1b[5]);
	and and22(g[7],a0b[7],a1b[6]);
	//assign g[8] = 1'b0;
	
	not not1(pbar[0],p[0]);
	not not2(pbar[1],p[1]);
	not not3(pbar[2],p[2]);
	not not4(pbar[3],p[3]);
	not not5(pbar[4],p[4]);
	not not6(pbar[5],p[5]);
	not not7(pbar[6],p[6]);
	not not8(pbar[7],p[7]);
	not not9(pbar[8],p[8]);
	
	//assign c[0]=1'b0;
	and and23(c[1],pbar[1],p[0]);
	and and24(c[2],pbar[2],p[1]);
	and and25(c[3],pbar[3],p[2]);
	and and26(c[4],pbar[4],p[3]);
	and and27(c[5],pbar[5],p[4]);
	and and28(c[6],pbar[6],p[5]);
	and and29(c[7],pbar[7],p[6]);
	and and30(c[8],pbar[8],p[7]);
	assign c[9]=p[8];

	//assign ov[0] = 1'b0;
	or or8(ov[1],c[1],g[1]);
	or or9(ov[2],c[2],g[2]);
	or or10(ov[3],c[3],g[3]);
	or or11(ov[4],c[4],g[4]);
	or or12(ov[5],c[5],g[5]);
	or or13(ov[6],c[6],g[6]);
	or or14(ov[7],c[7],g[7]);
	assign ov[8]=c[8];
	assign ov[9]=c[9];
	
	//assign cd = g[7]|g[6]|g[5];
	or or15(w,g[7],g[6]);
	or or16(cd,g[5],w);
	not not10(cdbar,cd);
	
	//assign myadder = ((~cond)&p)|(cond&ov);
	and and31(w1[0],cdbar,p[0]);
	and and32(w1[1],cdbar,p[1]);
	and and33(w1[2],cdbar,p[2]);
	and and34(w1[3],cdbar,p[3]);
	and and35(w1[4],cdbar,p[4]);
	and and36(w1[5],cdbar,p[5]);
	and and37(w1[6],cdbar,p[6]);
	and and38(w1[7],cdbar,p[7]);
	and and39(w1[8],cdbar,p[8]);
	
	and and41(w2[1],cd,ov[1]);
	and and42(w2[2],cd,ov[2]);
	and and43(w2[3],cd,ov[3]);
	and and44(w2[4],cd,ov[4]);
	and and45(w2[5],cd,ov[5]);
	and and46(w2[6],cd,ov[6]);
	and and47(w2[7],cd,ov[7]);
	and and48(w2[8],cd,ov[8]);
	and and49(w2[9],cd,ov[9]);
	
	assign myadder[0] = w1[0];
	or or17(myadder[1],w1[1],w2[1]);
	or or18(myadder[2],w1[2],w2[2]);
	or or19(myadder[3],w1[3],w2[3]);
	or or20(myadder[4],w1[4],w2[4]);
	or or21(myadder[5],w1[5],w2[5]);
	or or22(myadder[6],w1[6],w2[6]);
	or or23(myadder[7],w1[7],w2[7]);
	or or24(myadder[8],w1[8],w2[8]);
	assign myadder[9] = w2[9];
	
endmodule

module exact_pprow(
    input a,
    input [7:0]b,
    output [7:0]pprow
    );
		
	and a1(pprow[0],a,b[0]);
	and a2(pprow[1],a,b[1]);
	and a3(pprow[2],a,b[2]);
	and a4(pprow[3],a,b[3]);
	and a5(pprow[4],a,b[4]);
	and a6(pprow[5],a,b[5]);
	and a7(pprow[6],a,b[6]);
	and a8(pprow[7],a,b[7]);
	
endmodule

module FA(
    input a,
    input b,
    input cin,
    output sum,
    output cout
    );
    
    wire w1,w2,w3;
    
    xor x1(w1, a, b);
    xor x2(sum, w1, cin); //Sum
    and a1(w3, cin, w1);
    and a2(w2, a, b);
    or o1(cout, w2, w3); //Carry
endmodule

module HA(
    input wire a,
    input wire b,
	output wire sum,
	output wire carry
    );
	
	xor x1(sum,a,b);
	and a1(carry,a,b);
	
endmodule