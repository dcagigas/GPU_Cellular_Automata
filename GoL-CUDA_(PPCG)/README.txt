These codes were produced using the PPCG tool. 
The PPCG is avaialble at https://github.com/Meinersbur/ppcg.
Each folder contains a different GoL grid size (256, 512, ..., 16386).
The PPCG is also contained in the AN5D nvidia-container available at https://github.com/khaki3/AN5D-Artifact.


For example: for GoL grid size 256 the command "ppcg --target=cuda GOL_PPCG.c" produces files "GOL2_ready_for_ppcg_host.cu", "GOL2_ready_for_ppcg_kernel.cu" and "GOL2_ready_for_ppcg_kernel.hu" that are compiled using the NVIDIA "nvcc" compiler.

Important:
---------
To run examples is neccesary to increase the stack size of processes before executing them because arrays are too big.
In Linux just type in console:
ulimit -S -s 16777216
Then, run binary. 

