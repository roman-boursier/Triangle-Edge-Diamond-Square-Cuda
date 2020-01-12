NVCC=nvcc
CUDAFLAGS= -arch=sm_30
OPT= -g -G
RM=/bin/rm -f
OPENCV = -lm -lpng -lopencv_highgui -lopencv_imgproc -lopencv_core -lopencv_imgcodecs

main: functions.o main.o
	${NVCC} ${OPT} ${CUDAFLAGS} $(OPENCV) -o main functions.o main.o

functions.o: functions.cu
	${NVCC} ${OPT} ${CUDAFLAGS} -o functions.o -std=c++11 -c functions.cu

main.o: main.cu functions.cuh
	${NVCC} ${OPT} ${CUDAFLAGS} -o main.o -std=c++11 -c main.cu

clean:
	${RM} *.o

mrproper: clean
	rm -rf main