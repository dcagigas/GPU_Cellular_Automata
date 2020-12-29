all: clean GOL_custom4 


GOL_custom4: GOL_custom4.cu
	nvcc -arch=sm_75 -o GOL_custom4 GOL_custom4.cu


clean:
	rm -rf *.o GOL_custom4
