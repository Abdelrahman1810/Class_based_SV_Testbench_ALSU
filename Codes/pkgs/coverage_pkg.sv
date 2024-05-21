package coverage_pkg;
import shared_pkg::*;
import transaction_pkg::*;

class ALSU_coverage;
    ALSU_transaction tr = new();

    covergroup cvr_gp;
        // input A bins
            A_cp: coverpoint tr.A {
                bins A_data_0 = {ZERO};
                bins A_data_max = {MAXPOS};
                bins A_data_min = {MAXNEG};
                bins A_data_default = default;
                bins A_data_[] = {001, 010, 100};
            }

        // input B bins
            B_cp: coverpoint tr.B {
                bins B_data_0 = {ZERO};
                bins B_data_max = {MAXPOS};
                bins B_data_min = {MAXNEG};
                bins B_data_default = default;
                bins B_data_[] = {001, 010, 100};
            }

        // cover point for reduction operation red_op
            op_A_cp: coverpoint tr.red_op_A {
                bins one = {1};
                bins zero = {0};
            }
            op_B_cp: coverpoint tr.red_op_B {
                bins one = {1};
                bins zero = {0};
            }

        // Crossing to satsfied the data_walkingones of A and B
            A_walk: cross A_cp, op_A_cp {
                option.cross_auto_bin_max = 0;
                bins A_data_walkingones = binsof(A_cp.A_data_) && binsof(op_A_cp.one);
            }
            B_walk: cross B_cp, op_A_cp, op_B_cp {
                option.cross_auto_bin_max = 0;
                bins B_data_walkingones = (binsof(B_cp.B_data_) 
                                          && binsof(op_A_cp.zero) 
                                          && binsof(op_B_cp.one)); 
            }

        // cover point for tr.opcode (ALU)
            ALU_cp: coverpoint tr.opcode {
                bins Bins_shift[] = {SHIFT, ROTATE};
                bins Bins_arith[] = {ADD, MULT};
                bins Bins_bitwise[] = {OR, XOR};
                bins Bins_invalid = {INVALID_6, INVALID_7};
                bins Bins_trans = (OR => XOR => ADD => MULT => SHIFT => ROTATE);
            }
     
        // cover point for c_in
            cin_cp: coverpoint tr.cin;
        
        // cover point for tr.serial_in
            serial_cp: coverpoint tr.serial_in;
        
        // cover point for tr.direction
            direction_cp: coverpoint tr.direction;

        // Cross coverage between ALU_cp and A and B
            ALU_A: cross ALU_cp, A_cp {
                option.cross_auto_bin_max = 0;
                bins arith_permutations = binsof(ALU_cp.Bins_arith) && binsof(A_cp) intersect{ZERO, MAXPOS, MAXNEG};
            }
            ALU_B: cross ALU_cp, B_cp {
                option.cross_auto_bin_max = 0;
                bins arith_permutations = binsof(ALU_cp.Bins_arith) && binsof(B_cp) intersect{ZERO, MAXPOS, MAXNEG};
            }
        
        // Cross coverage between ALU_cp and cin_cp
            ALU_cin: cross ALU_cp, cin_cp {
                option.cross_auto_bin_max = 0;
                bins add_cin = binsof(ALU_cp) intersect{ADD};
            }
        
        // Cross coverage between ALU_cp and serial_cp
            ALU_serial: cross ALU_cp, serial_cp {
                option.cross_auto_bin_max = 0;
                bins shift_serial = binsof(ALU_cp) intersect{SHIFT};
            }
        
        // Cross coverage between ALU_cp and direction_cp
            ALU_direction: cross ALU_cp, direction_cp {
                option.cross_auto_bin_max = 0;
                bins sh_ro_direction = binsof(ALU_cp.Bins_shift);
            }    
    
        // Cross coverage ALU = {OR,XOR}, tr.red_op_A = 1, A = data_walk, B = 0
            A_data_walk_OR_XOR: cross ALU_cp, A_walk, op_A_cp, B_cp {
                option.cross_auto_bin_max = 0;
                bins A_walk_OR_XOR = (binsof(ALU_cp.Bins_bitwise) 
                                   && binsof(A_walk.A_data_walkingones)
                                   && binsof(op_A_cp.one)
                                   && binsof(B_cp.B_data_0));
            }
    
        // Cross coverage ALU = {OR,XOR}, tr.red_op_A = 1, A = data_walk, B = 0
            B_data_walk_OR_XOR: cross ALU_cp, B_walk, op_B_cp, A_cp {
                option.cross_auto_bin_max = 0;
                bins B_walk_OR_XOR = (binsof(ALU_cp.Bins_bitwise) 
                                   && binsof(B_walk.B_data_walkingones)
                                   && binsof(op_B_cp.one)
                                   && binsof(A_cp.A_data_0));
            }

        // Cross coverage Invalid case 2 red_op
            Invalid_red_op: cross ALU_cp, op_A_cp, op_B_cp {
                option.cross_auto_bin_max = 0;
                bins Invalid_reduction = (binsof(ALU_cp.Bins_bitwise)
                                         && (binsof(op_A_cp.one) || binsof(op_B_cp.one)));
            }
    
        // Invalid case with reduction operation
            reduction_invalid: cross ALU_cp, op_A_cp, op_B_cp {
                option.cross_auto_bin_max = 0;
                bins invalid_red_op = (binsof(ALU_cp) intersect{!OR, !XOR} && (binsof(op_A_cp.one)||binsof(op_B_cp.one)));
            }
        
        // cover point tr.rst
            rst_cp: coverpoint tr.rst;

        // Cross coverage tr.red_op_A and tr.red_op_B
            red_op_High_cross: cross op_A_cp, op_B_cp;
    endgroup

    function new();
        cvr_gp = new();
    endfunction //new()
    function void COV_sample(input ALSU_transaction take_tr);
        tr = take_tr;
        cvr_gp.sample();
    endfunction
endclass //coverage
endpackage