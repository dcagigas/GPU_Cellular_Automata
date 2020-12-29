#include "GOL2_ready_for_ppcg_kernel.hu"
__global__ void kernel0(int *grid)
{
    int b0 = blockIdx.x;
    int t0 = threadIdx.x;

    if (32 * b0 + t0 >= 1 && 32 * b0 + t0 <= 32769) {
      if (32 * b0 + t0 <= 16384) {
        grid[(32 * b0 + t0) * 16386 + 0] = grid[(32 * b0 + t0) * 16386 + 16384];
      } else if (32 * b0 + t0 >= 16386) {
        grid[(32 * b0 + t0 - 16385) * 16386 + 16385] = grid[(32 * b0 + t0 - 16385) * 16386 + 1];
      }
      if (b0 >= 512)
        grid[0 * 16386 + (32 * b0 + t0 - 16384)] = grid[16384 * 16386 + (32 * b0 + t0 - 16384)];
      if (32 * b0 + t0 <= 16386)
        grid[16385 * 16386 + (32 * b0 + t0 - 1)] = grid[1 * 16386 + (32 * b0 + t0 - 1)];
    }
}
__global__ void kernel1(int *grid, int *newGrid)
{
    int b0 = blockIdx.y, b1 = blockIdx.x;
    int t0 = threadIdx.y, t1 = threadIdx.x;
    int private_numNeighbors;

    #define ppcg_min(x,y)    ({ __typeof__(x) _x = (x); __typeof__(y) _y = (y); _x < _y ? _x : _y; })
    #define ppcg_max(x,y)    ({ __typeof__(x) _x = (x); __typeof__(y) _y = (y); _x > _y ? _x : _y; })
    for (int c0 = 32 * b0; c0 <= 16384; c0 += 8192)
      if (t0 + c0 >= 1 && t0 + c0 <= 16384)
        for (int c1 = ppcg_max(32 * b1 + 8192, 32 * b1 + 8192 * c0); c1 <= ppcg_min(134234112, 8192 * c0 + 270336); c1 += 8192)
          for (int c3 = ppcg_max(t1, ((t1 + c1 + 15) % 16) + 8192 * t0 + 8192 * c0 - c1 + 1); c3 <= ppcg_min(31, 8192 * t0 + 8192 * c0 - c1 + 16384); c3 += 16) {
            private_numNeighbors = (((((((grid[(t0 + c0 + 1) * 16386 + (-8192 * t0 - 8192 * c0 + c1 + c3)] + grid[(t0 + c0 - 1) * 16386 + (-8192 * t0 - 8192 * c0 + c1 + c3)]) + grid[(t0 + c0) * 16386 + (-8192 * t0 - 8192 * c0 + c1 + c3 + 1)]) + grid[(t0 + c0) * 16386 + (-8192 * t0 - 8192 * c0 + c1 + c3 - 1)]) + grid[(t0 + c0 + 1) * 16386 + (-8192 * t0 - 8192 * c0 + c1 + c3 + 1)]) + grid[(t0 + c0 - 1) * 16386 + (-8192 * t0 - 8192 * c0 + c1 + c3 - 1)]) + grid[(t0 + c0 - 1) * 16386 + (-8192 * t0 - 8192 * c0 + c1 + c3 + 1)]) + grid[(t0 + c0 + 1) * 16386 + (-8192 * t0 - 8192 * c0 + c1 + c3 - 1)]);
            if ((grid[(t0 + c0) * 16386 + (-8192 * t0 - 8192 * c0 + c1 + c3)] == 1) && (private_numNeighbors < 2)) {
              newGrid[(t0 + c0) * 16386 + (-8192 * t0 - 8192 * c0 + c1 + c3)] = 0;
            } else {
              if ((grid[(t0 + c0) * 16386 + (-8192 * t0 - 8192 * c0 + c1 + c3)] == 1) && ((private_numNeighbors == 2) || (private_numNeighbors == 3))) {
                newGrid[(t0 + c0) * 16386 + (-8192 * t0 - 8192 * c0 + c1 + c3)] = 1;
              } else {
                if ((grid[(t0 + c0) * 16386 + (-8192 * t0 - 8192 * c0 + c1 + c3)] == 1) && (private_numNeighbors > 3)) {
                  newGrid[(t0 + c0) * 16386 + (-8192 * t0 - 8192 * c0 + c1 + c3)] = 0;
                } else {
                  if ((grid[(t0 + c0) * 16386 + (-8192 * t0 - 8192 * c0 + c1 + c3)] == 0) && (private_numNeighbors == 3)) {
                    newGrid[(t0 + c0) * 16386 + (-8192 * t0 - 8192 * c0 + c1 + c3)] = 1;
                  } else {
                    newGrid[(t0 + c0) * 16386 + (-8192 * t0 - 8192 * c0 + c1 + c3)] = grid[(t0 + c0) * 16386 + (-8192 * t0 - 8192 * c0 + c1 + c3)];
                  }
                }
              }
            }
          }
}
