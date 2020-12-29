all: clean GOL_custom5 


GOL_custom5: GOL_custom5.cu
	nvcc -arch=sm_75 -o GOL_custom5 GOL_custom5.cu


clean:
	rm -rf *.o GOL_custom5
