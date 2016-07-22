DCC =dmd
DFLAGS = -w
LIB = $(wildcard ./lib/*.a)
SRC = $(wildcard ./src/*.d ./src/simple/*.d ./src/hashlife/*.d ./src/base/*.d)
OBJ = $(SRC:.d=.o)

all:
	$(DCC) $(DFLAGS) $(SRC) -L$(LIB)  -of./bin/life
	rm ./bin/*.o

clean:
	rm ./bin/*
