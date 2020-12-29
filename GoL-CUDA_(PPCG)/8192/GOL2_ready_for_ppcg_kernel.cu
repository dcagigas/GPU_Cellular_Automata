#include "GOL2_ready_for_ppcg_kernel.hu"
__global__ void kernel0(int *grid)
{
    int b0 = blockIdx.x;
    int t0 = threadIdx.x;

    if (32 * b0 + t0 >= 1 && 32 * b0 + t0 <= 16385) {
      if (32 * b0 + t0 <= 8192) {
        grid[(32 * b0 + t0) * 8194 + 0] = grid[(32 * b0 + t0) * 8194 + 8192];
      } else if (32 * b0 + t0 >= 8194) {
        grid[(32 * b0 + t0 - 8193) * 8194 + 8193] = grid[(32 * b0 + t0 - 8193) * 8194 + 1];
      }
      if (b0 >= 256)
        grid[0 * 8194 + (32 * b0 + t0 - 8192)] = grid[8192 * 8194 + (32 * b0 + t0 - 8192)];
      if (32 * b0 + t0 <= 8194)
        grid[8193 * 8194 + (32 * b0 + t0 - 1)] = grid[1 * 8194 + (32 * b0 + t0 - 1)];
    }
}
__global__ void kernel1(int *grid, int *newGrid)
{
    int b0 = blockIdx.y, b1 = blockIdx.x;
    int t0 = threadIdx.y, t1 = threadIdx.x;
    int private_numNeighbors;

    #define ppcg_min(x,y)    ({ __typeof__(x) _x = (x); __typeof__(y) _y = (y); _x < _y ? _x : _y; })
    #define ppcg_max(x,y)    ({ __typeof__(x) _x = (x); __typeof__(y) _y = (y); _x > _y ? _x : _y; })
    for (int c0 = 32 * b0; c0 <= 8192; c0 += 8192)
      if (t0 + c0 >= 1 && t0 + c0 <= 8192)
        for (int c1 = ppcg_max(32 * b1 + 4096 * c0, 32 * ((b1 + 128) % 256) + 4096); c1 <= ppcg_min(33562624, 4096 * c0 + 135168); c1 += 8192)
          for (int c3 = ppcg_max(t1, ((t1 + c1 + 15) % 16) + 4096 * t0 + 4096 * c0 - c1 + 1); c3 <= ppcg_min(31, 4096 * t0 + 4096 * c0 - c1 + 8192); c3 += 16) {
            private_numNeighbors = (((((((grid[(t0 + c0 + 1) * 8194 + (-4096 * t0 - 4096 * c0 + c1 + c3)] + grid[(t0 + c0 - 1) * 8194 + (-4096 * t0 - 4096 * c0 + c1 + c3)]) + grid[(t0 + c0) * 8194 + (-4096 * t0 - 4096 * c0 + c1 + c3 + 1)]) + grid[(t0 + c0) * 8194 + (-4096 * t0 - 4096 * c0 + c1 + c3 - 1)]) + grid[(t0 + c0 + 1) * 8194 + (-4096 * t0 - 4096 * c0 + c1 + c3 + 1)]) + grid[(t0 + c0 - 1) * 8194 + (-4096 * t0 - 4096 * c0 + c1 + c3 - 1)]) + grid[(t0 + c0 - 1) * 8194 + (-4096 * t0 - 4096 * c0 + c1 + c3 + 1)]) + grid[(t0 + c0 + 1) * 8194 + (-4096 * t0 - 4096 * c0 + c1 + c3 - 1)]);
            if ((grid[(t0 + c0) * 8194 + (-4096 * t0 - 4096 * c0 + c1 + c3)] == 1) && (private_numNeighbors < 2)) {
              newGrid[(t0 + c0) * 8194 + (-4096 * t0 - 4096 * c0 + c1 + c3)] = 0;
            } else {
              if ((grid[(t0 + c0) * 8194 + (-4096 * t0 - 4096 * c0 + c1 + c3)] == 1) && ((private_numNeighbors == 2) || (private_numNeighbors == 3))) {
                newGrid[(t0 + c0) * 8194 + (-4096 * t0 - 4096 * c0 + c1 + c3)] = 1;
              } else {
                if ((grid[(t0 + c0) * 8194 + (-4096 * t0 - 4096 * c0 + c1 + c3)] == 1) && (private_numNeighbors > 3)) {
                  newGrid[(t0 + c0) * 8194 + (-4096 * t0 - 4096 * c0 + c1 + c3)] = 0;
                } else {
                  if ((grid[(t0 + c0) * 8194 + (-4096 * t0 - 4096 * c0 + c1 + c3)] == 0) && (private_numNeighbors == 3)) {
                    newGrid[(t0 + c0) * 8194 + (-4096 * t0 - 4096 * c0 + c1 + c3)] = 1;
                  } else {
                    newGrid[(t0 + c0) * 8194 + (-4096 * t0 - 4096 * c0 + c1 + c3)] = grid[(t0 + c0) * 8194 + (-4096 * t0 - 4096 * c0 + c1 + c3)];
                  }
                }
              }
            }
          }
}
