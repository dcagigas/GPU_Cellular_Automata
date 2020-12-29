#include "GOL2_ready_for_ppcg_kernel.hu"
__global__ void kernel0(int *grid)
{
    int b0 = blockIdx.x;
    int t0 = threadIdx.x;

    if (32 * b0 + t0 >= 1 && 32 * b0 + t0 <= 4097) {
      if (32 * b0 + t0 <= 2048) {
        grid[(32 * b0 + t0) * 2050 + 0] = grid[(32 * b0 + t0) * 2050 + 2048];
      } else if (32 * b0 + t0 >= 2050) {
        grid[(32 * b0 + t0 - 2049) * 2050 + 2049] = grid[(32 * b0 + t0 - 2049) * 2050 + 1];
      }
      if (b0 >= 64)
        grid[0 * 2050 + (32 * b0 + t0 - 2048)] = grid[2048 * 2050 + (32 * b0 + t0 - 2048)];
      if (32 * b0 + t0 <= 2050)
        grid[2049 * 2050 + (32 * b0 + t0 - 1)] = grid[1 * 2050 + (32 * b0 + t0 - 1)];
    }
}
__global__ void kernel1(int *grid, int *newGrid)
{
    int b0 = blockIdx.y, b1 = blockIdx.x;
    int t0 = threadIdx.y, t1 = threadIdx.x;
    int private_numNeighbors;

    #define ppcg_min(x,y)    ({ __typeof__(x) _x = (x); __typeof__(y) _y = (y); _x < _y ? _x : _y; })
    #define ppcg_max(x,y)    ({ __typeof__(x) _x = (x); __typeof__(y) _y = (y); _x > _y ? _x : _y; })
    if (32 * b0 + t0 >= 1 && 32 * b0 + t0 <= 2048)
      for (int c1 = ppcg_max(32768 * b0 + 32 * b1, 32 * ((b1 + 224) % 256) + 1024); c1 <= ppcg_min(2099200, 32768 * b0 + 33792); c1 += 8192)
        for (int c3 = ppcg_max(t1, ((t1 + c1 + 15) % 16) + 32768 * b0 + 1024 * t0 - c1 + 1); c3 <= ppcg_min(31, 32768 * b0 + 1024 * t0 - c1 + 2048); c3 += 16) {
          private_numNeighbors = (((((((grid[(32 * b0 + t0 + 1) * 2050 + (-32768 * b0 - 1024 * t0 + c1 + c3)] + grid[(32 * b0 + t0 - 1) * 2050 + (-32768 * b0 - 1024 * t0 + c1 + c3)]) + grid[(32 * b0 + t0) * 2050 + (-32768 * b0 - 1024 * t0 + c1 + c3 + 1)]) + grid[(32 * b0 + t0) * 2050 + (-32768 * b0 - 1024 * t0 + c1 + c3 - 1)]) + grid[(32 * b0 + t0 + 1) * 2050 + (-32768 * b0 - 1024 * t0 + c1 + c3 + 1)]) + grid[(32 * b0 + t0 - 1) * 2050 + (-32768 * b0 - 1024 * t0 + c1 + c3 - 1)]) + grid[(32 * b0 + t0 - 1) * 2050 + (-32768 * b0 - 1024 * t0 + c1 + c3 + 1)]) + grid[(32 * b0 + t0 + 1) * 2050 + (-32768 * b0 - 1024 * t0 + c1 + c3 - 1)]);
          if ((grid[(32 * b0 + t0) * 2050 + (-32768 * b0 - 1024 * t0 + c1 + c3)] == 1) && (private_numNeighbors < 2)) {
            newGrid[(32 * b0 + t0) * 2050 + (-32768 * b0 - 1024 * t0 + c1 + c3)] = 0;
          } else {
            if ((grid[(32 * b0 + t0) * 2050 + (-32768 * b0 - 1024 * t0 + c1 + c3)] == 1) && ((private_numNeighbors == 2) || (private_numNeighbors == 3))) {
              newGrid[(32 * b0 + t0) * 2050 + (-32768 * b0 - 1024 * t0 + c1 + c3)] = 1;
            } else {
              if ((grid[(32 * b0 + t0) * 2050 + (-32768 * b0 - 1024 * t0 + c1 + c3)] == 1) && (private_numNeighbors > 3)) {
                newGrid[(32 * b0 + t0) * 2050 + (-32768 * b0 - 1024 * t0 + c1 + c3)] = 0;
              } else {
                if ((grid[(32 * b0 + t0) * 2050 + (-32768 * b0 - 1024 * t0 + c1 + c3)] == 0) && (private_numNeighbors == 3)) {
                  newGrid[(32 * b0 + t0) * 2050 + (-32768 * b0 - 1024 * t0 + c1 + c3)] = 1;
                } else {
                  newGrid[(32 * b0 + t0) * 2050 + (-32768 * b0 - 1024 * t0 + c1 + c3)] = grid[(32 * b0 + t0) * 2050 + (-32768 * b0 - 1024 * t0 + c1 + c3)];
                }
              }
            }
          }
        }
}
