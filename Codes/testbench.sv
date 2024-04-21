import ALSUPACKAGE::*;
module testbench ();
logic clk, rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
opcode_e opcode;
logic signed [2:0] A, B;
logic [15:0] leds_dut, leds_ref;
logic [5:0] out_dut, out_ref;
logic innvalid;
ALSUtransaction tr = new();
ALSU DUT(
    A, B, cin, serial_in, red_op_A, red_op_B, opcode,
    bypass_A, bypass_B, clk, rst, direction, leds_dut, out_dut
);
ALUS_ref REF(
    A, B, cin, serial_in, red_op_A, red_op_B,
    opcode, bypass_A, bypass_B, clk, rst, direction, leds_ref, out_ref
);  

initial begin
    clk = 0;
    forever
        #1 clk = ~clk;
end    

assign innvalid = REF.invalid;
initial begin
    // First loop turn off constraint 8
    tr.rules_8.constraint_mode(0);
    repeat(100_000) begin
        randomization;
        @(posedge clk);
        sample;
    end

    // Forced rst
    bypass_A = 0; bypass_B = 0;
    red_op_A = 0; red_op_B = 0;
    rst = 1; @(posedge clk); rst = 0;

    // Seconed loop turn ON constraint 8 and turn OFF other constraints
    tr.rules1_7.constraint_mode(0);
    tr.rules_8.constraint_mode(1);
    repeat(10_000) begin
        randomization;
        foreach(tr.arr[i])
            opcode = tr.arr[i];
        $display("arr = %p",tr.arr);
        @(posedge clk);
        sample;
    end
    $stop;
end

task randomization;
    assert(tr.randomize());
    rst = tr.rst;
    cin = tr.cin;
    red_op_A = tr.red_op_A;
    red_op_B = tr.red_op_B;
    bypass_A = tr.bypass_A;
    bypass_B = tr.bypass_B;
    direction = tr.direction;
    serial_in = tr.serial_in;
    opcode = tr.opcode;
    A = tr.A;
    B = tr.B;
endtask

task sample;
    if (~tr.rst||~bypass_A||~bypass_B) tr.cvr_gp.sample();
endtask

assert_invaled:         assert property (@(posedge clk) REF.invalid |-> DUT.invalid);
assert_invaled_opcode:  assert property (@(posedge clk) REF.invalid_c1 |-> DUT.invalid_opcode);
assert_invaled_ref_op:  assert property (@(posedge clk) REF.invalid_c2 |-> DUT.invalid_red_op);
assert_out:             assert property (@(posedge clk) (out_dut == out_ref));

endmodule