DCC =dmd
DFLAGS = -w
SRC = $(wildcard ./src/*.d ./src/simple/*.d ./src/hashlife/*.d)
OBJ = $(SRC:.d=.o)

all:
	$(DCC) $(DFLAGS) $(SRC) -of./bin/life
	rm ./bin/*.o

clean:
	rm ./bin/*
