#include <stdio.h>
#include <stdlib.h>
 
#define SRAND_VALUE 1985
#define BLOCK_SIZE 32

#define TIMESTEP 1024
#define SIDE 16384
#define CELL_TYPE int
#define CELL_NEIGHBOURS 8

// Classic GOL:
#define MIN_NOF_NEIGH_FROM_ALIVE_TO_ALIVE 2
#define MAX_NOF_NEIGH_FROM_ALIVE_TO_ALIVE 3
#define MIN_NOF_NEIGH_FROM_DEAD_TO_ALIVE 3
#define MAX_NOF_NEIGH_FROM_DEAD_TO_ALIVE 3

#define ALIVE  1
#define DEAD   0



__global__ void GOL(CELL_TYPE *d_grid, CELL_TYPE *d_newGrid)
{
    // We want id ∈ [1,dim]
    int i = blockDim.y * blockIdx.y + threadIdx.y;
    int j = blockDim.x * blockIdx.x + threadIdx.x;
    //int id = i * SIDE + j;

    __shared__ CELL_TYPE rule_table [2][CELL_NEIGHBOURS+1];

    if ( threadIdx.y < 2 && threadIdx.x < (CELL_NEIGHBOURS+1) ) {
        // Init rule_table for GOL
        // Classic B3S23 GOL:
	    //rule_table[cases] = {
		//    d,d,d,a, d,d,d,d,d // DEAD is current state
		//    d,d,a,a, d,d,d,d,d // ALIVE is current state
		    if (threadIdx.y==0) 
                if (threadIdx.x >= MIN_NOF_NEIGH_FROM_DEAD_TO_ALIVE && threadIdx.x <= MAX_NOF_NEIGH_FROM_DEAD_TO_ALIVE)
			        rule_table[threadIdx.y][threadIdx.x] = ALIVE;
		        else
			        rule_table[threadIdx.y][threadIdx.x] = DEAD; 
 
		    if (threadIdx.y==1) 
                if (threadIdx.x >= MIN_NOF_NEIGH_FROM_ALIVE_TO_ALIVE && threadIdx.x <= MAX_NOF_NEIGH_FROM_ALIVE_TO_ALIVE)
			        rule_table[threadIdx.y][threadIdx.x] =  ALIVE;
		        else
			        rule_table[threadIdx.y][threadIdx.x] = DEAD;  
    }
    __syncthreads();


    if (i < SIDE && j < SIDE) {
        CELL_TYPE (*grid)[SIDE] = (CELL_TYPE (*)[SIDE]) d_grid;
        CELL_TYPE (*newGrid)[SIDE] = (CELL_TYPE (*)[SIDE]) d_newGrid;

 		int a1 = (i - 1 + SIDE)% SIDE;
		int a2 = (i + 1)% SIDE;
		int a3 = (j - 1 + SIDE)% SIDE;
		int a4 = (j + 1)% SIDE;
 
        // Get the number of neighbors for a given grid point
        newGrid[i][j] = rule_table [ grid[i][j] ] [ (grid[a1][j] + grid[a2][j] + grid[i][a3] + grid[i][a4] + grid[a1][a3] + grid[a1][a4] + grid[a2][a3] + grid[a2][a4]) ];
    }
}
 

int main(int argc, char* argv[])
{
    int i,j,iter;
    CELL_TYPE* h_grid; //Grid on host
    CELL_TYPE* d_grid; //Grid on device
    CELL_TYPE* d_newGrid; //Second grid used on device only
    CELL_TYPE* d_tmpGrid; //tmp grid pointer used to switch between grid and newGrid
  
    size_t bytes = sizeof(CELL_TYPE)*SIDE*SIDE;
    // Allocate host Grid used for initial setup and read back from device
    h_grid = (int*)malloc(bytes);
 
    // Allocate device grids
    cudaMalloc(&d_grid, bytes);
    cudaMalloc(&d_newGrid, bytes);
 
    // Assign initial population randomly
    srand(SRAND_VALUE);
    for(i = 0; i<SIDE; i++) {
        for(j = 0; j<SIDE; j++) {
            h_grid[i*SIDE+j] = rand() % 2;
        }
    }
 
    // Copy over initial game grid (Dim-1 threads)
    cudaMemcpy(d_grid, h_grid, bytes, cudaMemcpyHostToDevice);
 
    dim3 blockSize(BLOCK_SIZE, BLOCK_SIZE,1);
    int linGrid = (int)ceil(SIDE/(float)BLOCK_SIZE);
    dim3 gridSize(linGrid,linGrid,1);
  

    // Main game loop
    for (iter = 0; iter<TIMESTEP; iter++) {
 
        GOL<<<gridSize, blockSize>>>(d_grid, d_newGrid);
 
        // Swap our grids and iterate again
        d_tmpGrid = d_grid;
        d_grid = d_newGrid;
        d_newGrid = d_tmpGrid;

    }//iter loop
 
    // Copy back results and sum
    cudaMemcpy(h_grid, d_grid, bytes, cudaMemcpyDeviceToHost);
 
    // Sum up alive cells and print results
    int total = 0;
    for (i = 0; i<SIDE; i++) {
        for (j = 0; j<SIDE; j++) {
            total += h_grid[i*SIDE+j];
        }
    }
    printf("Total Alive grid: %d\n", total);
 
    // Release memory
    cudaFree(d_grid);
    cudaFree(d_newGrid);
    free(h_grid);
 
    return 0;
}

// 256 Result in console: "Total Alive: 3281"
// 512 Result in console: "Total Alive: 11072"
// 1024 Result in console: "Total Alive: 45224"
// 2048 Result in console: "Total Alive: 182485"
// 4096 Result in console: "Total Alive: 724393"
// 8192 Result in console: "Total Alive: 2896683"
// 16384 Result in console: "Total Alive: 11547651"

