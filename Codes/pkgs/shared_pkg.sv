package shared_pkg;
    parameter INPUT_PRIORITY = "A";
    parameter FULL_ADDER = "ON";

    typedef enum reg [2:0] {OR, XOR, ADD, MULT, SHIFT, ROTATE, INVALID_6, INVALID_7} opcode_e;
    parameter MAXPOS = 3;
    parameter ZERO = 0; 
    parameter MAXNEG = -4;
    parameter RST_ACTIVATE = 5;
    parameter INVALID_ACTIVATE = 5;
    parameter BYPASS_ACTIVATE = 10;
    parameter REDACTION_ACTIVATE = 20;
    bit first_rst = 0;
    opcode_e valid_arr[] = {OR, XOR, ADD, MULT, SHIFT, ROTATE};
endpackage