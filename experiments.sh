
# adder
iverilog -o adder_test -s test src/adder.v test/adder_test.v
vvp adder_test
gtkwave test.vcd &

# comparator
iverilog -o ic74hc85_test -s test src/logic_modules.v test/ic74hc85_test.v
vvp ic74hc85_test
gtkwave test.vcd &

# multiplexer
iverilog -o ic74hc153_test -s test src/logic_modules.v test/ic74hc153_test.v
vvp ic74hc153_test
gtkwave test.vcd &

# decoder and encoder
iverilog -o ic74hc147_138_test -s test src/logic_modules.v test/ic74hc147_138_test.v
vvp ic74hc147_138_test
gtkwave test.vcd &
