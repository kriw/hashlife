#!/bin/sh

ROOT=.
DMD=dmd
SD=${ROOT}/src
SRCS="${SD}/main.d"
#SRCS="${SD}/main.d ${SD}/sdl/bindings.d"
OD=${ROOT}/obj
OF=${ROOT}/life
INC=${SD}
OPTS="-od${OD} -of${OF} -I${INC} -unittest -L-framework -LSDL2" 

${DMD} -v  ${SRCS} ${OPTS}
