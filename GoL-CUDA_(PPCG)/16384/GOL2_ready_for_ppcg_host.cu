#include <assert.h>
#include <stdio.h>
#include "GOL2_ready_for_ppcg_kernel.hu"
#include <stdio.h>
#include <stdlib.h>
 
#define SRAND_VALUE 1985

#define dim 16384
#define maxIter 1<<10

 
int print_total_alive (int grid[dim+2][dim+2]);

// Add up all neighbors


void make_Iter (int grid[dim+2][dim+2], int newGrid[dim+2][dim+2]) {
	int i,j, numNeighbors;
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

	  int *dev_grid;
	  int *dev_newGrid;
	  
	  cudaCheckReturn(cudaMalloc((void **) &dev_grid, (size_t)(16386) * (size_t)(16386) * sizeof(int)));
	  cudaCheckReturn(cudaMalloc((void **) &dev_newGrid, (size_t)(16385) * (size_t)(16386) * sizeof(int)));
	  
	  {
	  cudaCheckReturn(cudaMemcpy(dev_grid, grid, (size_t)(16386) * (size_t)(16386) * sizeof(int), cudaMemcpyHostToDevice));
	  #ifdef STENCILBENCH
	  cudaDeviceSynchronize();
	  SB_START_INSTRUMENTS;
	  #endif
	  }
	  {
	  cudaCheckReturn(cudaMemcpy(dev_newGrid, newGrid, (size_t)(16385) * (size_t)(16386) * sizeof(int), cudaMemcpyHostToDevice));
	  #ifdef STENCILBENCH
	  cudaDeviceSynchronize();
	  SB_START_INSTRUMENTS;
	  #endif
	  }
	  {
	    dim3 k0_dimBlock(32);
	    dim3 k0_dimGrid(1025);
	    kernel0 <<<k0_dimGrid, k0_dimBlock>>> (dev_grid);
	    cudaCheckKernel();
	  }
	  
	  {
	    dim3 k1_dimBlock(16, 32);
	    dim3 k1_dimGrid(256, 256);
	    kernel1 <<<k1_dimGrid, k1_dimBlock>>> (dev_grid, dev_newGrid);
	    cudaCheckKernel();
	  }
	  
	  {
	  #ifdef STENCILBENCH
	  cudaDeviceSynchronize();
	  SB_STOP_INSTRUMENTS;
	  #endif
	  cudaCheckReturn(cudaMemcpy(grid, dev_grid, (size_t)(16386) * (size_t)(16386) * sizeof(int), cudaMemcpyDeviceToHost));
	  }
	  {
	  #ifdef STENCILBENCH
	  cudaDeviceSynchronize();
	  SB_STOP_INSTRUMENTS;
	  #endif
	  cudaCheckReturn(cudaMemcpy(newGrid, dev_newGrid, (size_t)(16385) * (size_t)(16386) * sizeof(int), cudaMemcpyDeviceToHost));
	  }
	  cudaCheckReturn(cudaFree(dev_grid));
	  cudaCheckReturn(cudaFree(dev_newGrid));
	}
}


int main(int argc, char* argv[])
{
	int iter, i,j;
    int total = 0; 
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

    // Main game loop
    for (iter = 0; iter<maxIter; iter++) {
        // Left-Right columns

		if (iter%2==0) {
			make_Iter (grid, newGrid);
		} else {
			make_Iter (newGrid, grid);
		}
		
    }// End main game loop
		

	if (iter%2==0)
        total = print_total_alive (grid);
    else
        total = print_total_alive (newGrid);
    printf("Total Alive: %d\n", total);

	//
	
    return 0;
}


int print_total_alive (int grid[dim+2][dim+2]) {
	int i,j;
	int total = 0;
	for (i = 1; i<=dim; i++) {
		for (j = 1; j<=dim; j++) {
			total += grid[i][j];
		}
	}
	//printf("Total Alive: %d\n", total);
	return total;
}

// Result in console: "Total Alive: 45224"
	
