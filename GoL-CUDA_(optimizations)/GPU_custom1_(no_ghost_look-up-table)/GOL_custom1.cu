#include <stdio.h>
#include <stdlib.h>
 
#define SRAND_VALUE 1985
#define BLOCK_SIZE 32

#define TIMESTEP 1024
#define SIDE 16384
#define CELL_TYPE int
#define CELL_NEIGHBOURS 8

// Classic GOL:
#define MIN_NOF_NEIGH_FROM_ALIVE_TO_DEAD 2
#define MAX_NOF_NEIGH_FROM_ALIVE_TO_DEAD 3
#define MIN_NOF_NEIGH_FROM_DEAD_TO_ALIVE 3
#define MAX_NOF_NEIGH_FROM_DEAD_TO_ALIVE 3

#define ALIVE  1
#define DEAD   0

void print_matrix (CELL_TYPE *d_grid) {
    CELL_TYPE (*grid)[SIDE] = (CELL_TYPE (*)[SIDE]) d_grid;
    for(int i = 0; i<SIDE; i++) {
        for(int j = 0; j<SIDE; j++) {
            printf ("%d ", (int)grid[i][j]);
        }
            printf ("\n");
    }
}


__global__ void kernel_init_rule_table (CELL_TYPE *GPU_rule_table) {
    int i, idx = blockIdx.x * blockDim.x + threadIdx.x;
    int stride = gridDim.x * blockDim.x;
    int value_alive, value_dead;

    // RULE COMPUTATION USING A TABLE . TABLE IS USED BELOW
	/* two simple examples
	    int d = DEAD, a = ALIVE;
    // Classic GOL:
	    rule_table[cases] = {
		    d,d,d,a, a,d,d,d, d, // DEAD is current state
		    d,d,d,d, a,a,d,d, d // ALIVE is current state
	    };
	*/
    for (i = idx; i < (CELL_NEIGHBOURS+1); i+= stride) {
		if (!(i >= MIN_NOF_NEIGH_FROM_ALIVE_TO_DEAD && i <= MAX_NOF_NEIGH_FROM_ALIVE_TO_DEAD))
			value_alive = DEAD;
		else
			value_alive = ALIVE;  

		if (i >= MIN_NOF_NEIGH_FROM_DEAD_TO_ALIVE && i <= MAX_NOF_NEIGH_FROM_DEAD_TO_ALIVE)
			value_dead = ALIVE;
		else
			value_dead = DEAD; 
 
		GPU_rule_table[i] = value_dead;
		GPU_rule_table[i + (CELL_NEIGHBOURS + 1)] = value_alive;

    }
}


__global__ void GOL(CELL_TYPE *d_grid, CELL_TYPE *d_newGrid, CELL_TYPE * GPU_rule_table)
{
    // We want id ∈ [1,dim]
    int i = blockDim.y * blockIdx.y + threadIdx.y;
    int j = blockDim.x * blockIdx.x + threadIdx.x;
    //int id = iy * SIDE + ix;

    if (i < SIDE && j < SIDE) {
        CELL_TYPE (*grid)[SIDE] = (CELL_TYPE (*)[SIDE]) d_grid;
        CELL_TYPE (*newGrid)[SIDE] = (CELL_TYPE (*)[SIDE]) d_newGrid;
        CELL_TYPE (*rule_table)[CELL_NEIGHBOURS+1] = (CELL_TYPE (*)[CELL_NEIGHBOURS+1]) GPU_rule_table;
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
    CELL_TYPE *GPU_rule_table;
  
    size_t bytes = sizeof(CELL_TYPE)*SIDE*SIDE;
    // Allocate host Grid used for initial setup and read back from device
    h_grid = (int*)malloc(bytes);
 
    // Allocate device grids
    cudaMalloc(&d_grid, bytes);
    cudaMalloc(&d_newGrid, bytes);
    cudaMalloc(&GPU_rule_table, sizeof(CELL_TYPE)*2*(CELL_NEIGHBOURS+1));
 
    // Assign initial population randomly
    srand(SRAND_VALUE);
    for(i = 0; i<SIDE; i++) {
        for(j = 1; j<SIDE; j++) {
            h_grid[i*SIDE+j] = rand() % 2;
        }
    }
 
    // Copy over initial game grid (Dim-1 threads)
    cudaMemcpy(d_grid, h_grid, bytes, cudaMemcpyHostToDevice);
 
//print_matrix (h_grid);
//printf("\n");

    dim3 blockSize(BLOCK_SIZE, BLOCK_SIZE,1);
    int linGrid = (int)ceil(SIDE/(float)BLOCK_SIZE);
    dim3 gridSize(linGrid,linGrid,1);
  
    kernel_init_rule_table<<<1,blockSize>>>(GPU_rule_table);

    // Main game loop
    for (iter = 0; iter<TIMESTEP; iter++) {
 
        GOL<<<gridSize, blockSize>>>(d_grid, d_newGrid, GPU_rule_table);

//cudaMemcpy(h_grid, d_newGrid, bytes, cudaMemcpyDeviceToHost);
//print_matrix (h_grid);
//printf("\n");
 
        // Swap our grids and iterate again
        d_tmpGrid = d_grid;
        d_grid = d_newGrid;
        d_newGrid = d_tmpGrid;

//cudaMemcpy(h_grid, d_grid, bytes, cudaMemcpyDeviceToHost);
//print_matrix (h_grid);
//printf("\n");


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
 
/*    cudaMemcpy(h_grid, d_newGrid, bytes, cudaMemcpyDeviceToHost);
 
    // Sum up alive cells and print results
    total=0;
    for (i = 0; i<SIDE; i++) {
        for (j = 0; j<SIDE; j++) {
            total += h_grid[i*SIDE+j];
        }
    }

    printf("Total Alive newGrid: %d\n", total);
*/

    // Release memory
    cudaFree(d_grid);
    cudaFree(d_newGrid);
    cudaFree(GPU_rule_table);
    free(h_grid);
 
    return 0;
}
