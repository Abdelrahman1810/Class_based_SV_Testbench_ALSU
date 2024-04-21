





vlib work
vlog package.sv ALSU.v ALUS_ref.sv testbench.sv
vsim -voptargs=+acc work.testbench
add wave *

add wave /testbench/assert_invaled_opcode /testbench/assert_invaled /testbench/assert_invaled_ref_op /testbench/assert_out

#add wave -position insertpoint  \
#sim:/testbench/DUT/invalid_opcode

run -all
## quit -sim






#vlib work
#
#vlog -coveropt 3 +cover +acc package.sv ALSU.v ALUS_ref.v testbench.sv
#
#vsim -voptargs=+acc work.testbench
#
#vsim -coverage -vopt work.testbench -c -do "add wave *; coverage save -onexit -du ALSU -directive -codeAll cover.ucdb; run -all"
#                                                          
#coverage report -detail -cvg -directive -comments -output {F:/digital verification/Session 4/New folder/FUNCTION_COVER_ALSU.txt} {}
#
#quit -sim
#
#vcover report cover.ucdb -details -all -annotate -output cover_alsu.txt
#
#vcover report -html cover.ucdb