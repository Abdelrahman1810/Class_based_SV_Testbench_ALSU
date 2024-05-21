vlib work

vlog -coveropt 3 +cover +acc {Codes/pkgs/shared_pkg.sv}
vlog -coveropt 3 +cover +acc {Codes/pkgs/transaction_pkg.sv}
vlog -coveropt 3 +cover +acc {Codes/pkgs/coverage_pkg.sv}
##
vlog -coveropt 3 +cover +acc {Codes/Design/ALSU.v}
vlog -coveropt 3 +cover +acc {Codes/Design/ALSU_sva.sv}
##
vlog -coveropt 3 +cover +acc {Codes/golden_model/ALUS_ref.sv}
##
vlog -coveropt 3 +cover +acc {Codes/testbench/testbench.sv}

vsim -voptargs=+acc work.testbench
add wave *

add wave /testbench/assert_invaled
add wave /testbench/assert_invaled_opcode
add wave /testbench/assert_invaled_ref_op
add wave /testbench/assert_out
add wave /testbench/sva/redA_OR_assert
add wave /testbench/sva/redB_OR_assert
add wave /testbench/sva/redA_XR_assert
add wave /testbench/sva/redB_XR_assert
add wave /testbench/sva/Invalid_assert
add wave /testbench/sva/OR_assert
add wave /testbench/sva/XOR_assert
add wave /testbench/sva/add_assert
add wave /testbench/sva/mult_assert
add wave /testbench/sva/shiftL_assert
add wave /testbench/sva/shiftR_assert
add wave /testbench/sva/rotateL_assert
add wave /testbench/sva/rotateR_assert

add wave /testbench/sva/reset_assertion/rst_out_assert
add wave /testbench/sva/reset_assertion/rst_leds_assert

# free commands from line 41 to 49 and comment line 39 to extract cover reports 
run -all

#vsim -coverage -vopt work.testbench -c -do "coverage save -onexit -du ALSU -directive -codeAll cover.ucdb; run -all"
##                                                          
#coverage report -detail -cvg -directive -comments -output {Reports\FUNCTION_COVER_ALSU.txt} {}
##
#quit -sim
##
#vcover report cover.ucdb -details -all -annotate -output  {Reports\cover_alsu.txt} 
##
#vcover report -html cover.ucdb -output  {Reports\html_report\.} 