#!/bin/sh

TESTS=(
	00_assignment
	01_comment
	02_printf
	03_struct
	04_for
	05_array
	06_case
	07_function
	08_while
	09_do_while
	10_pointer
	11_precedence
	12_hashdefine
	13_integer_literals
	14_if
	15_recursion
	16_nesting
	17_enum
	# 18_include parse includes better
	19_pointer_arithmetic
	20_pointer_comparison
	21_char_array
	22_floating_point
	23_type_coercion
	24_math_library
	25_quicksort
	26_character_constants
	27_sizeof
	28_strings
	29_array_address
	# 30_hanoi seg fault in gcc
	# 31_args no args in testing script
	32_led
	33_ternary_op
	# 34_array_assignment gcc error
	35_sizeof
	36_array_initialisers
	37_sprintf
	38_multiple_array_index
	39_typedef
	# 40_stdio Uses FILE
	# 41_hashif parse includes better
	# 42_function_pointer int (*f)(int);
	43_void_param
	44_scoped_declarations
	45_empty_for
	# 46_grep broken in gcc
	47_switch_return
	48_nested_break
	49_bracket_evaluation
	50_logical_second_arg
	51_static
	52_unnamed_enum
	54_goto
	55_array_initialiser
	56_cross_structure
	57_macro_bug
	58_return_outside
	59_break_before_loop
	60_local_vars
	61_initializers
	62_float
	# 63_typedef char* y = (char*) &x32;
	64_double_prefix_op
	65_typeless
	66_printf_undefined
	67_macro_crash
	68_return
	# 69_lshift_type (unsigned long int)(1);
)

for i in "${TESTS[@]}"
do
	echo Test: $i
	LIBS=($(grep 'include' tcc_tests/`echo $i`.c | cut -d ' ' -f 2 | tr -d '<>' ))
	grep -vwE "include" tcc_tests/$i.c > temp.c
	gcc -E -P temp.c > preprocessed.c
	node c_printer.js preprocessed.c > output.c

	INCLUDES=()
	for LIB in "${LIBS[@]}"; do
	    INCLUDES+=("-include ${LIB} ")
	done
	gcc `echo "${INCLUDES[@]}"` output.c && ./a.out > $i.output
	
	if diff -bu tcc_tests/$i.expect $i.output
	then 
		rm -f preprocessed.c
		rm -f temp.c
		rm -f $i.output
		echo "Passed"
	else 
		echo "Failed"
		exit 1
	fi
done