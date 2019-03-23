PROJECT=boothr4
FILES=src
TEST=testbench
OUT=obj
OBJ=boothr4
HDL=iverilog
GTKWAVE=gtkwave

MODULES=\
	$(FILES)/booth_algo.v \
	$(FILES)/boothr4.v \
	$(FILES)/control_unit.v


all: compile


compile:
	mkdir -p $(OUT)
	$(HDL) $(MODULES) $(TEST)/boothr4_tb.v -o $(OUT)/$(OBJ)

run:
	vvp $(OUT)/$(OBJ)
	mv $(OBJ).vcd $(OUT)/

view:
	$(GTKWAVE) $(OUT)/$(OBJ).vcd
clean:
	rm -r $(OUT)
