package ALSUPACKAGE;
    typedef enum reg [2:0] {OR, XOR, ADD, MULT, SHIFT, ROTATE, INVALID_6, INVALID_7} opcode_e;
    parameter MAXPOS = 3;
    parameter ZERO = 0; 
    parameter MAXNEG = -4;

class ALSUtransaction;
    bit first_rst = 0;
    rand opcode_e opcode;    
    rand bit rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
    rand bit signed [2:0] A, B;

    constraint rules1_7 {
        //rst constraint
            rst dist {0:=95, 1:=5};

        // Invalid cases constraint
            opcode dist {INVALID_6:=5, INVALID_7:=5, [0:5]:/90};

        // A & B constraint when opcode is ADD or MULT
            (opcode == MULT || opcode == ADD) -> A dist {MAXPOS:=20, ZERO:=10, MAXNEG:=20, [MAXNEG+1:MAXPOS-1]:/50};
            (opcode == MULT || opcode == ADD) -> B dist {MAXPOS:=20, ZERO:=10, MAXNEG:=20, [MAXNEG+1:MAXPOS-1]:/50};

        // A & B constraint when opcode is OR or XOR and red_op_A is high
            ((opcode==XOR || opcode==OR) && red_op_A) -> A dist {3'b001:=30, 3'b010:=30, 3'b100:=30, [MAXNEG+1:MAXPOS-1]:/10};
            ((opcode==XOR || opcode==OR) && red_op_A) -> B == 0;

        // A & B constraint when opcode is OR or XOR and red_op_B is high
            ((opcode==XOR || opcode==OR) && red_op_B) -> A == 0;
            ((opcode==XOR || opcode==OR) && red_op_B) -> B dist {3'b001:=30, 3'b010:=30, 3'b100:=30, [MAXNEG+1:MAXPOS-1]:/10};

        //  Do not constraint the inputs A or B when the operation is shift or rotate
        // it's achieved by default after the 2,3 and 4 Constraint achieved

        // bypass constraint
            bypass_A dist {0:=90, 1:=10};
            bypass_B dist {0:=90, 1:=10};

        // red_op constraint
            red_op_A dist {0:=90, 1:=10};
            red_op_B dist {0:=90, 1:=10};

        // A & B constraint when opcode is OR or XOR and red_op is low
            ((opcode==XOR || opcode==OR) && ~red_op_A && ~red_op_B) -> A == ~B;
    }

    rand opcode_e arr [6];
    constraint rules_8 {
        foreach(arr[i])
            arr[i] inside {OR, XOR, ADD, MULT, SHIFT, ROTATE};
        unique {arr};
    }

    covergroup cvr_gp@(posedge clk);
        // input A bins
            A_cp: coverpoint A {
                bins A_data_0 = {ZERO};
                bins A_data_max = {MAXPOS};
                bins A_data_min = {MAXNEG};
                bins A_data_default = default;
                bins A_data_[] = {001, 010, 100};
            }

        // input B bins
            B_cp: coverpoint B {
                bins B_data_0 = {ZERO};
                bins B_data_max = {MAXPOS};
                bins B_data_min = {MAXNEG};
                bins B_data_default = default;
                bins B_data_[] = {001, 010, 100};
            }

        // cover point for reduction operation red_op
            op_A_cp: coverpoint red_op_A {
                bins one = {1};
                bins zero = {0};
                option.weight = 0;
            }
            op_B_cp: coverpoint red_op_B {
                bins one = {1};
                bins zero = {0};
                option.weight = 0;
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

        // cover point for opcode (ALU)
            ALU_cp: coverpoint opcode {
                bins Bins_shift[] = {SHIFT, ROTATE};
                bins Bins_arith[] = {ADD, MULT};
                bins Bins_bitwise[] = {OR, XOR};//
                bins Bins_invalid = {INVALID_6, INVALID_7};
                bins Bins_trans = (0 => 1 => 2 => 3 => 4 => 5);
            }
     
        // cover point for c_in
            cin_cp: coverpoint cin {
                option.weight = 0;
            }
        
        // cover point for serial_in
            serial_cp: coverpoint serial_in{
                option.weight = 0;
            }
        
        // cover point for direction
            direction_cp: coverpoint direction{
                option.weight = 0;
            }

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
    
        // Cross coverage ALU = {OR,XOR}, red_op_A = 1, A = data_walk, B = 0
            A_data_walk_OR_XOR: cross ALU_cp, A_walk, op_A_cp, B_cp {
                option.cross_auto_bin_max = 0;
                bins A_walk_OR_XOR = (binsof(ALU_cp.Bins_bitwise) 
                                   && binsof(A_walk.A_data_walkingones)
                                   && binsof(op_A_cp.one)
                                   && binsof(B_cp.B_data_0));
            }
    
        // Cross coverage ALU = {OR,XOR}, red_op_A = 1, A = data_walk, B = 0
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
            reduction_invalid: cross ALU_cp, red_op_A, red_op_B {
                option.cross_auto_bin_max = 0;
                bins invalid_red_op = (~binsof(ALU_cp.Bins_bitwise) && (binsof(red_op_A.one)||binsof(red_op_B.one)));
            }
        
        // cover point rst
            rst_cp: coverpoint rst {
                option.weight = 0;
            }
    endgroup

    function new();
        cvr_gp = new();
    endfunction //new()
    function void post_randomize();
        if(!first_rst) rst = 1;
        first_rst = 1;
    endfunction 
endclass //ALSUtransaction
endpackage