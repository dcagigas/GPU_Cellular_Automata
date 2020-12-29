#include <stdio.h>
#include <stdlib.h>
 
#define SRAND_VALUE 1985
#define BLOCK_SIZE 32

#define TIMESTEP 1024
#define SIDE 16384
#define CELL_TYPE int
#define CELL_NEIGHBOURS 8

 
__global__ void GOL(CELL_TYPE *d_grid, CELL_TYPE *d_newGrid)
{
    // We want id ∈ [1,dim]
    int iy = blockDim.y * blockIdx.y + threadIdx.y;
    int ix = blockDim.x * blockIdx.x + threadIdx.x;
    int id = iy * SIDE + ix;
 
    if (iy < SIDE && ix < SIDE) {
        CELL_TYPE (*grid)[SIDE] = (CELL_TYPE (*)[SIDE]) d_grid;
        //CELL_TYPE (*newGrid)[SIDE] = (CELL_TYPE (*)[SIDE]) d_newGrid;
 		int a1 = (iy - 1 + SIDE)% SIDE;
		int a2 = (iy + 1)% SIDE;
		int a3 = (ix - 1 + SIDE)% SIDE;
		int a4 = (ix + 1)% SIDE;
 
        // Get the number of neighbors for a given grid point
        int numNeighbors = (grid[a1][ix] + grid[a2][ix] + grid[iy][a3] + grid[iy][a4] + grid[a1][a3] + grid[a1][a4] + grid[a2][a3] + grid[a2][a4]);
 
        CELL_TYPE cell = d_grid[id];
        // Here we have explicitly all of the game rules
        if (cell == 1 && numNeighbors < 2)
            d_newGrid[id] = 0;
        else if (cell == 1 && (numNeighbors == 2 || numNeighbors == 3))
            d_newGrid[id] = 1;
        else if (cell == 1 && numNeighbors > 3)
            d_newGrid[id] = 0;
        else if (cell == 0 && numNeighbors == 3)
            d_newGrid[id] = 1;
        else
            d_newGrid[id] = cell;
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

