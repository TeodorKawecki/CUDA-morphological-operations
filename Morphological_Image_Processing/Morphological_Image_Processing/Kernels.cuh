#pragma once
#include <cuda.h>
#include "cuda_runtime.h"
#include <cuda_runtime_api.h>
#include "device_launch_parameters.h"
#include "IImage.h"
#include <iostream>

#define gpuErrchk(ans) { gpuAssert((ans), __FILE__, __LINE__); }
inline void gpuAssert(cudaError_t code, const char *file, int line, bool abort = true)
{
	if (code != cudaSuccess)
	{
		fprintf(stderr, "GPUassert: %s %s %d\n", cudaGetErrorString(code), file, line);
		if (abort) exit(code);
	}
}

constexpr static int THREAD_NUMBER = 1024;

__device__ PixelsPtrType inputImageDev;
__device__ PixelsPtrType tempImageDev;
__device__ PixelsPtrType outputImageDev;

__global__ void ErosionDev(const PixelsPtrType inputImageDev, const size_t widthImg, const size_t hightImg, const size_t maskSize, PixelsPtrType outputImageDev);
__global__ void DilationDev(const PixelsPtrType inputImageDev, const size_t widthImg, const size_t hightImg, const size_t maskSize, PixelsPtrType outputImageDev);

PixelsPtrType Erosion(const PixelsPtrType inputImage, const size_t widthImg, const size_t hightImg, const size_t maskSize);
PixelsPtrType Dilation(const PixelsPtrType inputImage, const size_t widthImg, const size_t hightImg, const size_t maskSize);
PixelsPtrType Opening(const PixelsPtrType inputImage, const size_t widthImg, const size_t hightImg, const size_t maskSize);
PixelsPtrType Closing(const PixelsPtrType inputImage, const size_t widthImg, const size_t hightImg, const size_t maskSize);

void AllocGpuMemory(size_t imageSizeBytes);
void FreeGpuMemory();


