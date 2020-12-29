These codes were produced using the AN5D tool running in a nvidia-container. 
The AN5D nvidia-docker is avaialble at https://github.com/khaki3/AN5D-Artifact was used.
Each folder contains a different GoL grid size (256, 512, ..., 16386).


For example: for GoL grid size 256 the command "an5d GOL_AN5D_256.c" produces files "GOL_AN5D_256_host.cu", "GOL_AN5D_256_kernel.cu" and "GOL_AN5D_256_kernel.hu" that are compiled using the NVIDIA "nvcc" compiler.

