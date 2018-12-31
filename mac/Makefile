CC=clash
FLAGS=-Wall -Werror -threaded -rtsopts -with-rtsopts=-N 
MODULE=MAC
OUT=obj
HDL=verilog
#can be vhdl or systemverilog

all:create_dir build move_files

create_dir:
	mkdir -p $(OUT)
    
build:
	$(CC) $(FLAGS) $(MODULE).hs

move_files:create_dir
	mv *.dyn_* $(OUT)
	mv *.hi *.o $(OUT)

clean:
	rm -r $(OUT)
	rm -r generated

generate:
	mkdir -p $(OUT)
	$(CC) $(FLAGS) --$(HDL) $(MODULE).hs
	mv *.dyn_* $(OUT)
	mv *.hi *.o $(OUT)
	mkdir -p generated
	mv $(HDL) generated/
