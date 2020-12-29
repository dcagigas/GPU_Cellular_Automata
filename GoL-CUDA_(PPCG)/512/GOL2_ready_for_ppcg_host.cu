#include <assert.h>
#include <stdio.h>
#include "GOL2_ready_for_ppcg_kernel.hu"
#include <stdio.h>
#include <stdlib.h>
 
#define SRAND_VALUE 1985

#define dim 512
#define maxIter 1<<10
 
long int print_total_alive (int *h_grid);

// Add up all neighbors


void make_Iter (int *dev_grid, int *dev_newGrid) {
	{
#define cudaCheckReturn(ret) \
  do { \
    cudaError_t cudaCheckReturn_e = (ret); \
    if (cudaCheckReturn_e != cudaSuccess) { \
      fprintf(stderr, "CUDA error: %s\n", cudaGetErrorString(cudaCheckReturn_e)); \
      fflush(stderr); \
    } \
    assert(cudaCheckReturn_e == cudaSuccess); \
  } while(0)
#define cudaCheckKernel() \
  do { \
    cudaCheckReturn(cudaGetLastError()); \
  } while(0)


	  {
	    dim3 k0_dimBlock(32);
	    dim3 k0_dimGrid(33);
	    kernel0 <<<k0_dimGrid, k0_dimBlock>>> (dev_grid);
	    cudaCheckKernel();
	  }
	  
	  {
	    dim3 k1_dimBlock(16, 32);
	    dim3 k1_dimGrid(256, 17);
	    kernel1 <<<k1_dimGrid, k1_dimBlock>>> (dev_grid, dev_newGrid);
	    cudaCheckKernel();
	  }
	  
	}
}


int main(int argc, char* argv[])
{
	int iter, i,j;
    long int total = 0; 
	int *dev_grid;
	int *dev_newGrid;
	int grid[dim+2][dim+2];
	int newGrid[dim+2][dim+2];
	
	
	//printf ("Random - s\n");
    // Assign initial population randomly
    srand(SRAND_VALUE);
    for(i = 1; i<=dim; i++) {
        for(j = 1; j<=dim; j++) {
            grid[i][j] = rand() % 2;
        }
    }

	  cudaCheckReturn(cudaMalloc((void **) &dev_grid, (514) * (514) * sizeof(int)));
	  cudaCheckReturn(cudaMalloc((void **) &dev_newGrid, (513) * (514) * sizeof(int)));
	  
	  cudaCheckReturn(cudaMemcpy(dev_grid, grid, (514) * (514) * sizeof(int), cudaMemcpyHostToDevice));


    // Main game loop
    for (iter = 0; iter<maxIter; iter++) {
        // Left-Right columns

		if (iter%2==0) {
			make_Iter (dev_grid, dev_newGrid);
		} else {
			make_Iter (dev_newGrid, dev_grid);
		}
		
    }// End main game loop

    if (iter%2==0) {
        cudaCheckReturn(cudaMemcpy(grid, dev_grid, (dim+2) * (dim+2) * sizeof(int), cudaMemcpyDeviceToHost));
        total = print_total_alive ((int *)grid);
    } else {
        cudaCheckReturn(cudaMemcpy(newGrid, dev_newGrid, (dim+1) * (dim+2) * sizeof(int), cudaMemcpyDeviceToHost));
        total = print_total_alive ((int *)newGrid);
    }
	cudaCheckReturn(cudaFree(dev_grid));
	cudaCheckReturn(cudaFree(dev_newGrid));
	
    printf("Total Alive: %ld\n", total);
	
    return 0;
}


long int print_total_alive (int *h_grid) {
	int i,j;
	long int total = 0;
	for (i = 1; i<=dim; i++) {
		for (j = 1; j<=dim; j++) {
            total += h_grid[i*(dim+2)+j];
		}
	}
	return total;
}

// Result in console: "Total Alive: 11072"
	
