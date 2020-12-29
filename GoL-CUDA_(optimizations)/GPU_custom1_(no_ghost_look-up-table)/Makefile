all: clean GOL_custom 


GOL_custom: GOL_custom1.cu
	nvcc -arch=sm_75 -o GOL_custom GOL_custom1.cu


clean:
	rm -rf *.o GOL_custom
