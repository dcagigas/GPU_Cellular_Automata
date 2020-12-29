#include "GOL2_ready_for_ppcg_kernel.hu"
__global__ void kernel0(int *grid)
{
    int b0 = blockIdx.x;
    int t0 = threadIdx.x;

    if (32 * b0 + t0 >= 1 && 32 * b0 + t0 <= 2049) {
      if (32 * b0 + t0 <= 1024) {
        grid[(32 * b0 + t0) * 1026 + 0] = grid[(32 * b0 + t0) * 1026 + 1024];
      } else if (32 * b0 + t0 >= 1026) {
        grid[(32 * b0 + t0 - 1025) * 1026 + 1025] = grid[(32 * b0 + t0 - 1025) * 1026 + 1];
      }
      if (b0 >= 32)
        grid[0 * 1026 + (32 * b0 + t0 - 1024)] = grid[1024 * 1026 + (32 * b0 + t0 - 1024)];
      if (32 * b0 + t0 <= 1026)
        grid[1025 * 1026 + (32 * b0 + t0 - 1)] = grid[1 * 1026 + (32 * b0 + t0 - 1)];
    }
}
__global__ void kernel1(int *grid, int *newGrid)
{
    int b0 = blockIdx.y, b1 = blockIdx.x;
    int t0 = threadIdx.y, t1 = threadIdx.x;
    int private_numNeighbors;

    #define ppcg_min(x,y)    ({ __typeof__(x) _x = (x); __typeof__(y) _y = (y); _x < _y ? _x : _y; })
    #define ppcg_max(x,y)    ({ __typeof__(x) _x = (x); __typeof__(y) _y = (y); _x > _y ? _x : _y; })
    if (32 * b0 + t0 >= 1 && 32 * b0 + t0 <= 1024)
      for (int c1 = ppcg_max(16384 * b0 + 32 * b1, 32 * ((b1 + 240) % 256) + 512); c1 <= ppcg_min(525312, 16384 * b0 + 16896); c1 += 8192)
        for (int c3 = ppcg_max(t1, ((t1 + c1 + 15) % 16) + 16384 * b0 + 512 * t0 - c1 + 1); c3 <= ppcg_min(31, 16384 * b0 + 512 * t0 - c1 + 1024); c3 += 16) {
          private_numNeighbors = (((((((grid[(32 * b0 + t0 + 1) * 1026 + (-16384 * b0 - 512 * t0 + c1 + c3)] + grid[(32 * b0 + t0 - 1) * 1026 + (-16384 * b0 - 512 * t0 + c1 + c3)]) + grid[(32 * b0 + t0) * 1026 + (-16384 * b0 - 512 * t0 + c1 + c3 + 1)]) + grid[(32 * b0 + t0) * 1026 + (-16384 * b0 - 512 * t0 + c1 + c3 - 1)]) + grid[(32 * b0 + t0 + 1) * 1026 + (-16384 * b0 - 512 * t0 + c1 + c3 + 1)]) + grid[(32 * b0 + t0 - 1) * 1026 + (-16384 * b0 - 512 * t0 + c1 + c3 - 1)]) + grid[(32 * b0 + t0 - 1) * 1026 + (-16384 * b0 - 512 * t0 + c1 + c3 + 1)]) + grid[(32 * b0 + t0 + 1) * 1026 + (-16384 * b0 - 512 * t0 + c1 + c3 - 1)]);
          if ((grid[(32 * b0 + t0) * 1026 + (-16384 * b0 - 512 * t0 + c1 + c3)] == 1) && (private_numNeighbors < 2)) {
            newGrid[(32 * b0 + t0) * 1026 + (-16384 * b0 - 512 * t0 + c1 + c3)] = 0;
          } else {
            if ((grid[(32 * b0 + t0) * 1026 + (-16384 * b0 - 512 * t0 + c1 + c3)] == 1) && ((private_numNeighbors == 2) || (private_numNeighbors == 3))) {
              newGrid[(32 * b0 + t0) * 1026 + (-16384 * b0 - 512 * t0 + c1 + c3)] = 1;
            } else {
              if ((grid[(32 * b0 + t0) * 1026 + (-16384 * b0 - 512 * t0 + c1 + c3)] == 1) && (private_numNeighbors > 3)) {
                newGrid[(32 * b0 + t0) * 1026 + (-16384 * b0 - 512 * t0 + c1 + c3)] = 0;
              } else {
                if ((grid[(32 * b0 + t0) * 1026 + (-16384 * b0 - 512 * t0 + c1 + c3)] == 0) && (private_numNeighbors == 3)) {
                  newGrid[(32 * b0 + t0) * 1026 + (-16384 * b0 - 512 * t0 + c1 + c3)] = 1;
                } else {
                  newGrid[(32 * b0 + t0) * 1026 + (-16384 * b0 - 512 * t0 + c1 + c3)] = grid[(32 * b0 + t0) * 1026 + (-16384 * b0 - 512 * t0 + c1 + c3)];
                }
              }
            }
          }
        }
}
