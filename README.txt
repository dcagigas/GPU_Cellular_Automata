Contents:
--------

This code repostory contains Game of Life (GoL) versions implemented in CUDA. These codes can be adapted to implement other Celullar Automata. 

1) GoL-CUDA_(global, shared and textures memory models): CUDA code for the Game of Life (GoL). Three possible solutions: using only GPU global memory, using shared memory and using textures. The global memory GoL version is considered the baseline GoL version.

2) GoL-CUDA_(optimizations): five  variations of the CUDA GoL global memory version. Some use Look-up Tables instead of ifs to code rules, other use shared memory to store the Look-up Tables, and other don't use ghost row/columns.

3) GoL-CUDA_(PPCG): versions of the GoL that use PPCG for CUDA automatic code generation.

4) GoL-CUDA_(AN5D): AN5D CUDA automatic code generated for the GoL. This code can speed-up the baseline GoL version up to 33% for large grids.

5) GoL-CUDA_(packet-coding): This code can speed-up the baseline GoL version more than 100% for large grids.

