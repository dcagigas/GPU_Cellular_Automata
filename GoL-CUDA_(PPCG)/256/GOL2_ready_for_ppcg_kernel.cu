#include "GOL2_ready_for_ppcg_kernel.hu"
__global__ void kernel0(int *grid)
{
    int b0 = blockIdx.x;
    int t0 = threadIdx.x;

    if (32 * b0 + t0 >= 1 && 32 * b0 + t0 <= 513) {
      if (32 * b0 + t0 <= 256) {
        grid[(32 * b0 + t0) * 258 + 0] = grid[(32 * b0 + t0) * 258 + 256];
      } else if (32 * b0 + t0 >= 258) {
        grid[(32 * b0 + t0 - 257) * 258 + 257] = grid[(32 * b0 + t0 - 257) * 258 + 1];
      }
      if (b0 >= 8)
        grid[0 * 258 + (32 * b0 + t0 - 256)] = grid[256 * 258 + (32 * b0 + t0 - 256)];
      if (32 * b0 + t0 <= 258)
        grid[257 * 258 + (32 * b0 + t0 - 1)] = grid[1 * 258 + (32 * b0 + t0 - 1)];
    }
}
__global__ void kernel1(int *grid, int *newGrid)
{
    int b0 = blockIdx.y, b1 = blockIdx.x;
    int t0 = threadIdx.y, t1 = threadIdx.x;
    int private_numNeighbors;

    #define ppcg_min(x,y)    ({ __typeof__(x) _x = (x); __typeof__(y) _y = (y); _x < _y ? _x : _y; })
    #define ppcg_max(x,y)    ({ __typeof__(x) _x = (x); __typeof__(y) _y = (y); _x > _y ? _x : _y; })
    #define ppcg_fdiv_q(n,d) (((n)<0) ? -((-(n)+(d)-1)/(d)) : (n)/(d))
    if (32 * b0 + t0 >= 1 && 32 * b0 + t0 <= 256 && b1 + 256 * ppcg_fdiv_q(128 * b0 - b1 - 1, 256) >= -252 && b1 + 256 * ppcg_fdiv_q(128 * b0 - b1 - 1, 256) <= 776)
      for (int c3 = ppcg_max(t1, ((t1 + 15) % 16) + 4096 * b0 - 32 * b1 + 128 * t0 - 8192 * ppcg_fdiv_q(128 * b0 - b1 - 1, 256) - 8191); c3 <= ppcg_min(31, 4096 * b0 - 32 * b1 + 128 * t0 - 8192 * ppcg_fdiv_q(128 * b0 - b1 - 1, 256) - 7936); c3 += 16) {
        private_numNeighbors = (((((((grid[(32 * b0 + t0 + 1) * 258 + (32 * ((128 * b0 + b1) % 256) - 128 * t0 + c3)] + grid[(32 * b0 + t0 - 1) * 258 + (32 * ((128 * b0 + b1) % 256) - 128 * t0 + c3)]) + grid[(32 * b0 + t0) * 258 + (32 * ((128 * b0 + b1) % 256) - 128 * t0 + c3 + 1)]) + grid[(32 * b0 + t0) * 258 + (32 * ((128 * b0 + b1) % 256) - 128 * t0 + c3 - 1)]) + grid[(32 * b0 + t0 + 1) * 258 + (32 * ((128 * b0 + b1) % 256) - 128 * t0 + c3 + 1)]) + grid[(32 * b0 + t0 - 1) * 258 + (32 * ((128 * b0 + b1) % 256) - 128 * t0 + c3 - 1)]) + grid[(32 * b0 + t0 - 1) * 258 + (32 * ((128 * b0 + b1) % 256) - 128 * t0 + c3 + 1)]) + grid[(32 * b0 + t0 + 1) * 258 + (32 * ((128 * b0 + b1) % 256) - 128 * t0 + c3 - 1)]);
        if ((grid[(32 * b0 + t0) * 258 + (32 * ((128 * b0 + b1) % 256) - 128 * t0 + c3)] == 1) && (private_numNeighbors < 2)) {
          newGrid[(32 * b0 + t0) * 258 + (32 * ((128 * b0 + b1) % 256) - 128 * t0 + c3)] = 0;
        } else {
          if ((grid[(32 * b0 + t0) * 258 + (32 * ((128 * b0 + b1) % 256) - 128 * t0 + c3)] == 1) && ((private_numNeighbors == 2) || (private_numNeighbors == 3))) {
            newGrid[(32 * b0 + t0) * 258 + (32 * ((128 * b0 + b1) % 256) - 128 * t0 + c3)] = 1;
          } else {
            if ((grid[(32 * b0 + t0) * 258 + (32 * ((128 * b0 + b1) % 256) - 128 * t0 + c3)] == 1) && (private_numNeighbors > 3)) {
              newGrid[(32 * b0 + t0) * 258 + (32 * ((128 * b0 + b1) % 256) - 128 * t0 + c3)] = 0;
            } else {
              if ((grid[(32 * b0 + t0) * 258 + (32 * ((128 * b0 + b1) % 256) - 128 * t0 + c3)] == 0) && (private_numNeighbors == 3)) {
                newGrid[(32 * b0 + t0) * 258 + (32 * ((128 * b0 + b1) % 256) - 128 * t0 + c3)] = 1;
              } else {
                newGrid[(32 * b0 + t0) * 258 + (32 * ((128 * b0 + b1) % 256) - 128 * t0 + c3)] = grid[(32 * b0 + t0) * 258 + (32 * ((128 * b0 + b1) % 256) - 128 * t0 + c3)];
              }
            }
          }
        }
      }
}
