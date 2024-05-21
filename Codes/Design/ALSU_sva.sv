import shared_pkg::*;
`define mk_assert(condition) assert property (@(posedge clk) disable iff(rst) condition)
`define mk_cover(condition) cover property (@(posedge clk) disable iff(rst) condition)
module ALSU_sva(A, B, cin, serial_in, red_op_A, red_op_B, opcode, bypass_A, bypass_B, clk, rst, direction, leds, out);
input bit clk;
input logic rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
input opcode_e opcode;
input logic signed [2:0] A, B;
input logic [15:0] leds;
input logic [5:0] out;

////////////////////////////////////////////////////////
// this variable to make writing assertion more easer //
////////////////////////////////////////////////////////
bit isBypass, InvalidOP, bitwise;
assign isBypass = bypass_A | bypass_B;
assign InvalidOP = opcode==6 | opcode==7;
assign bitwise = opcode==0 | opcode==1;
assign isRed = red_op_B | red_op_A;

///////////////////////////////////
// assertion of bypass operation //
///////////////////////////////////
bypass_A_assert: `mk_assert(bypass_A |-> ##2 out==$past(A,2));
bypass_B_assert: `mk_assert((bypass_B && !bypass_A) |-> ##2 out==$past(B,2));

//////////////////////////////////////
// assertion of reduction operation //
//////////////////////////////////////
sequence redValid(red, op,red2);
    (red && !isBypass && opcode==op && !red2);
endsequence

redA_OR_assert: `mk_assert(redValid(red_op_A,OR,0)        |-> ##2 out==|($past(A,2)));
redB_OR_assert: `mk_assert(redValid(red_op_B,OR,red_op_A) |-> ##2 out==|($past(B,2)));

redA_XR_assert: `mk_assert(redValid(red_op_A,XOR,0)        |-> ##2 out==^($past(A,2)));
redB_XR_assert: `mk_assert(redValid(red_op_B,XOR,red_op_A) |-> ##2 out==^($past(B,2)));

////////////////////////////////
// assertion of invalid cases //
////////////////////////////////
sequence Invalid_seq;
    ((isRed && !isBypass && !bitwise) || (InvalidOP && !isBypass));
endsequence

Invalid_assert: `mk_assert(Invalid_seq |-> ##[0:2](out==0 && leds=='hffff));

/////////////////////
// reset assertion //
/////////////////////
always_comb begin : reset_assertion
    if (rst) begin
        rst_out_assert: assert final (out==0);
        rst_leds_assert: assert final (leds==0);
    end
end

//////////////////////////////////////////////////////////////////
// assertion for opcode Valid cases without bypass or reduction //
//////////////////////////////////////////////////////////////////
sequence sh_ro(op, dir);
    (opcode==op && dir && !isRed && !isBypass);
endsequence
sequence op_assert(op);
  (!isBypass && !isRed && opcode==op);
endsequence
  
OR_assert:   `mk_assert(op_assert(0) |-> ##2  out== $past(A,2) | $past(B,2) );
XOR_assert:  `mk_assert(op_assert(1) |-> ##2  out==($past(A,2)^$past(B,2)) );
add_assert:  `mk_assert(op_assert(2) |-> ##2  out==($past(A,2)+$past(B,2)+$past(cin,2)) );
mult_assert: `mk_assert(op_assert(3) |-> ##2  out==($past(A,2)*$past(B,2)) );

shiftL_assert: `mk_assert(sh_ro(4, direction) |-> ##2  out=={$past(out[4:0]), $past(serial_in,2)} ); 
shiftR_assert: `mk_assert(sh_ro(4, !direction) |-> ##2  out=={$past(serial_in,2), $past(out[5:1])} ); 

rotateL_assert: `mk_assert(sh_ro(5, direction) |-> ##2  out=={$past(out[4:0]), $past(out[5])} ); 
rotateR_assert: `mk_assert(sh_ro(5, !direction) |-> ##2  out=={$past(out[0]), $past(out[5:1])} );

/////////////////////////////////////////////////////////////////////////////
//////////////////////////          cover          //////////////////////////
/////////////////////////////////////////////////////////////////////////////

///////////////////////////////
// cover of bypass operation //
///////////////////////////////
bypass_A_cover: `mk_cover( bypass_A |-> ##2 out==$past(A,2)); 
bypass_B_cover: `mk_cover( (bypass_B && !bypass_A) |-> ##2 out==$past(B,2));

//////////////////////////////////
// cover of reduction operation //
//////////////////////////////////

redA_OR_cover: `mk_cover( redValid(red_op_A,0,0)        |-> ##2 out==|($past(A,2)));
redB_OR_cover: `mk_cover( redValid(red_op_B,0,red_op_A) |-> ##2 out==|($past(B,2)));

redA_XR_cover: `mk_cover( redValid(red_op_A,1,0)        |-> ##2 out==^($past(A,2)));
redB_XR_cover: `mk_cover( redValid(red_op_B,1,red_op_A) |-> ##2 out==^($past(B,2)));

////////////////////////////
// cover of invalid cases //
////////////////////////////
Invalid_cover: `mk_cover( Invalid_seq |-> ##[0:2](out==0 && leds=='hffff));

/////////////////
// reset cover //
/////////////////
always_comb begin : reset_cover
    if (rst) begin
        rst_out_cover: cover final (out==0);
        rst_leds_cover: cover final (leds==0);
    end
end

//////////////////////////////////////////////////////////////
// cover for opcode Valid cases without bypass or reduction //
//////////////////////////////////////////////////////////////
  
OR_cover:   `mk_cover( op_assert(0) |-> ##2  out== $past(A,2) | $past(B,2) );
XOR_cover:  `mk_cover( op_assert(1) |-> ##2  out==($past(A,2) ^ $past(B,2)) );
add_cover:  `mk_cover( op_assert(2) |-> ##2  out==($past(A,2) + $past(B,2) + $past(cin,2)) );
mult_cover: `mk_cover( op_assert(3) |-> ##2  out==($past(A,2) * $past(B,2)) );

shiftL_cover: `mk_cover( sh_ro(4, direction) |-> ##2  out=={$past(out[4:0]), $past(serial_in,2)} ); 
shiftR_cover: `mk_cover( sh_ro(4, !direction) |-> ##2  out=={$past(serial_in,2), $past(out[5:1])} ); 

rotateL_cover: `mk_cover( sh_ro(5, direction) |-> ##2  out=={$past(out[4:0]), $past(out[5])} ); 
rotateR_cover: `mk_cover( sh_ro(5, !direction) |-> ##2  out=={$past(out[0]), $past(out[5:1])} );
endmodule