package transaction_pkg;
import shared_pkg::*;

class ALSU_transaction;
    rand opcode_e opcode;    
    rand bit rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
    rand bit signed [2:0] A, B;
    bit [1:0]red_op_parameterTest;
    constraint rules1_7 {
        //rst constraint
            rst dist {0:=100-RST_ACTIVATE, 1:=RST_ACTIVATE};

        // Invalid cases constraint
            opcode dist {INVALID_6:=INVALID_ACTIVATE, INVALID_7:=INVALID_ACTIVATE, [0:5]:/100-2*INVALID_ACTIVATE};

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
            bypass_A dist {0:=100-BYPASS_ACTIVATE, 1:=BYPASS_ACTIVATE};
            bypass_B dist {0:=100-BYPASS_ACTIVATE, 1:=BYPASS_ACTIVATE};

        // red_op constraint
            red_op_A dist {0:=100-REDACTION_ACTIVATE, 1:=REDACTION_ACTIVATE};
            red_op_B dist {0:=100-REDACTION_ACTIVATE, 1:=REDACTION_ACTIVATE};

        // A & B constraint when opcode is OR or XOR and red_op is low
            ((opcode==XOR || opcode==OR) && ~red_op_A && ~red_op_B) -> A == ~B;
    }

    rand opcode_e arr [6];
    constraint rules_8 {
        foreach(arr[i])
            arr[i] inside {valid_arr};
        unique {arr};
    }

    function new();
    endfunction //new()
    function void post_randomize();
        if(!first_rst) rst = 1;
        first_rst = 1;
        if (red_op_parameterTest!=2'b11 && !rst && !bypass_A && !bypass_B) begin
            if (opcode==OR) begin
                red_op_A = 1;
                red_op_B = 1;
                red_op_parameterTest[0] = 1;
            end
            if (opcode==XOR) begin
                red_op_A = 1;
                red_op_B = 1;
                red_op_parameterTest[1] = 1;
            end
        end
    endfunction
endclass //ALSUtransaction
endpackage