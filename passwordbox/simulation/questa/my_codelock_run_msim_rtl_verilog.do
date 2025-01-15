transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Verilog/passwordbox {C:/Verilog/passwordbox/my_codelock.v}
vlog -vlog01compat -work work +incdir+C:/Verilog/passwordbox {C:/Verilog/passwordbox/Verilog2.v}

