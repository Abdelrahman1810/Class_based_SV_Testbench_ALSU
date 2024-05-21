import shared_pkg::*;
import coverage_pkg::*;
import transaction_pkg::*;
`define reset disable iff(rst)
`define mk_assertion(sva_assert) assert property (@(posedge clk) disable iff(rst) (sva_assert))

module testbench ();
logic clk, rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
opcode_e opcode;
logic signed [2:0] A, B;
logic [15:0] leds, leds_ref;
logic [5:0] out, out_ref;
ALSU_transaction tr = new();
ALSU_coverage cov = new();

ALSU DUT(.*);
ALSU_sva sva(.*);
ALUS_ref REF(
    A, B, cin, serial_in, red_op_A, red_op_B,
    opcode, bypass_A, bypass_B, clk, rst, direction, leds_ref, out_ref
);  

initial begin
    clk = 0;
    forever
        #1 clk = ~clk;
end    

initial begin
    // First loop turn off constraint 8
    tr.rules_8.constraint_mode(0);
    repeat(500_000) begin
        randomization;
        @(negedge clk);
        sample;
    end

    // Forced rst
    bypass_A = 0; bypass_B = 0;
    red_op_A = 0; red_op_B = 0;
    rst = 1; @(negedge clk); rst = 0;

    // Seconed loop turn ON constraint 8 and turn OFF other constraints
    tr.rules1_7.constraint_mode(0);
    tr.rules_8.constraint_mode(1);
    repeat(10_000) begin
        randomization(1);
        foreach(tr.arr[i]) begin
            opcode = tr.arr[i];
            tr.opcode = tr.arr[i];
            @(negedge clk);
            sample;
        end 
        $display("arr = %p",tr.arr);
    end
    $stop;
end

task randomization(bit con_rule8 = 0);
    assert(tr.randomize());
    if (!con_rule8) begin
        rst = tr.rst;
        bypass_A = tr.bypass_A;
        bypass_B = tr.bypass_B;
        red_op_A = tr.red_op_A;
        red_op_B = tr.red_op_B;
    end
    cin = tr.cin;
    direction = tr.direction;
    serial_in = tr.serial_in;
    opcode = tr.opcode;
    A = tr.A;
    B = tr.B;
endtask

task sample;
    if (~tr.rst||~bypass_A||~bypass_B) cov.COV_sample(tr);
endtask

assert_invaled:         assert property (@(posedge clk) disable iff(rst) REF.invalid |-> DUT.invalid);
assert_invaled_opcode:  assert property (@(posedge clk) disable iff(rst) REF.invalid_opcode |-> DUT.invalid_opcode);
assert_invaled_ref_op:  assert property (@(posedge clk) disable iff(rst) REF.invalid_red |-> DUT.invalid_red_op);
assert_out:             assert property (@(posedge clk) (out == out_ref));
endmodule