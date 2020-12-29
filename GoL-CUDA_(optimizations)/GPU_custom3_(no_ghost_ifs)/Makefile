all: clean GOL_custom3 


GOL_custom3: GOL_custom3.cu
	nvcc -arch=sm_75 -o GOL_custom3 GOL_custom3.cu


clean:
	rm -rf *.o GOL_custom3
