PROJECT=booth
FILES=src
TEST=testbench
OUT=obj
OBJ=booth
HDL=iverilog
FLAGS=-g2005-sv
GTKWAVE=gtkwave

MODULES=\
	$(FILES)/booth.v \
	$(FILES)/adder.v \
	$(FILES)/control_unit.v \
	$(FILES)/d_ff.v \
	$(FILES)/register.v

all: compile


compile:
	mkdir -p $(OUT)
	$(HDL) $(FLAGS) $(MODULES) $(TEST)/booth_tb.v -o $(OUT)/$(OBJ)

run:
	vvp $(OUT)/$(OBJ)
	mv $(OBJ).vcd $(OUT)/

view:
	$(GTKWAVE) $(OUT)/$(OBJ).vcd
clean:
	rm -r $(OUT)
