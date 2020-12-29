#include "GOL2_ready_for_ppcg_kernel.hu"
__global__ void kernel0(int *grid)
{
    int b0 = blockIdx.x;
    int t0 = threadIdx.x;

    if (32 * b0 + t0 >= 1 && 32 * b0 + t0 <= 8193) {
      if (32 * b0 + t0 <= 4096) {
        grid[(32 * b0 + t0) * 4098 + 0] = grid[(32 * b0 + t0) * 4098 + 4096];
      } else if (32 * b0 + t0 >= 4098) {
        grid[(32 * b0 + t0 - 4097) * 4098 + 4097] = grid[(32 * b0 + t0 - 4097) * 4098 + 1];
      }
      if (b0 >= 128)
        grid[0 * 4098 + (32 * b0 + t0 - 4096)] = grid[4096 * 4098 + (32 * b0 + t0 - 4096)];
      if (32 * b0 + t0 <= 4098)
        grid[4097 * 4098 + (32 * b0 + t0 - 1)] = grid[1 * 4098 + (32 * b0 + t0 - 1)];
    }
}
__global__ void kernel1(int *grid, int *newGrid)
{
    int b0 = blockIdx.y, b1 = blockIdx.x;
    int t0 = threadIdx.y, t1 = threadIdx.x;
    int private_numNeighbors;

    #define ppcg_min(x,y)    ({ __typeof__(x) _x = (x); __typeof__(y) _y = (y); _x < _y ? _x : _y; })
    #define ppcg_max(x,y)    ({ __typeof__(x) _x = (x); __typeof__(y) _y = (y); _x > _y ? _x : _y; })
    if (32 * b0 + t0 >= 1 && 32 * b0 + t0 <= 4096)
      for (int c1 = ppcg_max(65536 * b0 + 32 * b1, 32 * ((b1 + 192) % 256) + 2048); c1 <= ppcg_min(8392704, 65536 * b0 + 67584); c1 += 8192)
        for (int c3 = ppcg_max(t1, ((t1 + c1 + 15) % 16) + 65536 * b0 + 2048 * t0 - c1 + 1); c3 <= ppcg_min(31, 65536 * b0 + 2048 * t0 - c1 + 4096); c3 += 16) {
          private_numNeighbors = (((((((grid[(32 * b0 + t0 + 1) * 4098 + (-65536 * b0 - 2048 * t0 + c1 + c3)] + grid[(32 * b0 + t0 - 1) * 4098 + (-65536 * b0 - 2048 * t0 + c1 + c3)]) + grid[(32 * b0 + t0) * 4098 + (-65536 * b0 - 2048 * t0 + c1 + c3 + 1)]) + grid[(32 * b0 + t0) * 4098 + (-65536 * b0 - 2048 * t0 + c1 + c3 - 1)]) + grid[(32 * b0 + t0 + 1) * 4098 + (-65536 * b0 - 2048 * t0 + c1 + c3 + 1)]) + grid[(32 * b0 + t0 - 1) * 4098 + (-65536 * b0 - 2048 * t0 + c1 + c3 - 1)]) + grid[(32 * b0 + t0 - 1) * 4098 + (-65536 * b0 - 2048 * t0 + c1 + c3 + 1)]) + grid[(32 * b0 + t0 + 1) * 4098 + (-65536 * b0 - 2048 * t0 + c1 + c3 - 1)]);
          if ((grid[(32 * b0 + t0) * 4098 + (-65536 * b0 - 2048 * t0 + c1 + c3)] == 1) && (private_numNeighbors < 2)) {
            newGrid[(32 * b0 + t0) * 4098 + (-65536 * b0 - 2048 * t0 + c1 + c3)] = 0;
          } else {
            if ((grid[(32 * b0 + t0) * 4098 + (-65536 * b0 - 2048 * t0 + c1 + c3)] == 1) && ((private_numNeighbors == 2) || (private_numNeighbors == 3))) {
              newGrid[(32 * b0 + t0) * 4098 + (-65536 * b0 - 2048 * t0 + c1 + c3)] = 1;
            } else {
              if ((grid[(32 * b0 + t0) * 4098 + (-65536 * b0 - 2048 * t0 + c1 + c3)] == 1) && (private_numNeighbors > 3)) {
                newGrid[(32 * b0 + t0) * 4098 + (-65536 * b0 - 2048 * t0 + c1 + c3)] = 0;
              } else {
                if ((grid[(32 * b0 + t0) * 4098 + (-65536 * b0 - 2048 * t0 + c1 + c3)] == 0) && (private_numNeighbors == 3)) {
                  newGrid[(32 * b0 + t0) * 4098 + (-65536 * b0 - 2048 * t0 + c1 + c3)] = 1;
                } else {
                  newGrid[(32 * b0 + t0) * 4098 + (-65536 * b0 - 2048 * t0 + c1 + c3)] = grid[(32 * b0 + t0) * 4098 + (-65536 * b0 - 2048 * t0 + c1 + c3)];
                }
              }
            }
          }
        }
}
