#include "Kernels.cuh"

void AllocGpuMemory(size_t imageSizeBytes)
{
	gpuErrchk(cudaMallocManaged(&inputImageDev, imageSizeBytes));
	gpuErrchk(cudaMallocManaged(&tempImageDev, imageSizeBytes));
	gpuErrchk(cudaMallocManaged(&outputImageDev, imageSizeBytes));
}

void FreeGpuMemory()
{
	if(inputImageDev != nullptr)
	      gpuErrchk(cudaFree(inputImageDev));

	if(tempImageDev != nullptr)
	      gpuErrchk(cudaFree(tempImageDev));

	if(outputImageDev != nullptr)
	      gpuErrchk(cudaFree(outputImageDev));
}

__device__ void FixIndexes(int &pixelX,  int &pixelY, size_t hightImg, size_t widthImg)
{
	if (pixelX < 0)
		pixelX = 0;

	if (pixelY < 0)
		pixelY = 0;

	if (pixelX >= hightImg)
		pixelX = hightImg - 1;

	if (pixelY >= widthImg)
		pixelY = widthImg - 1;
}

__global__ void ErosionDev(const PixelsPtrType inputImage, const size_t widthImg, const size_t hightImg, const size_t maskSize, PixelsPtrType outputImage)
{
	int threadIndex = blockIdx.x * blockDim.x + threadIdx.x;
	int mainPixelX = threadIndex / widthImg;
	int mainPixelY = threadIndex % widthImg;

	if (threadIndex >= widthImg * hightImg)
	{
		return;
	}

	int halfSide = (int)((maskSize - 1) / 2);
	bool foundZero = false;

	for (int row = -halfSide; row <= halfSide && !foundZero; ++row)
	{
		for (int col = -halfSide; col <= halfSide && !foundZero; ++col)
		{
			int currentPixelX = mainPixelX + row;
			int currentPixelY = mainPixelY + col;

			FixIndexes(currentPixelX, currentPixelY, hightImg, widthImg);

			if(inputImage[currentPixelX * widthImg + currentPixelY] == 0)
			{
			  foundZero = true;
			  break;
			}
		}
	}

	if(foundZero)
	{
	  outputImage[threadIndex] = 0;
	}
	else
	{
	  outputImage[threadIndex] = 1;
	}
}

__global__ void DilationDev(const PixelsPtrType inputImage, const size_t widthImg, const size_t hightImg, const size_t maskSize, PixelsPtrType outputImage)
{
	int threadIndex = blockIdx.x * blockDim.x + threadIdx.x;
	int mainPixelX = threadIndex / widthImg;
	int mainPixelY = threadIndex % widthImg;

	if (threadIndex >= widthImg * hightImg)
	{
		return;
	}

	int halfSide = (int)((maskSize - 1) / 2);
	bool foundOne = false;

	for (int row = -halfSide; row <= halfSide && !foundOne; ++row)
	{
		for (int col = -halfSide; col <= halfSide && !foundOne; ++col)
		{
			int currentPixelX = mainPixelX + row;
			int currentPixelY = mainPixelY + col;

			FixIndexes(currentPixelX, currentPixelY, hightImg, widthImg);

			if(inputImage[currentPixelX * widthImg + currentPixelY] > 0)
			{
			  foundOne = true;
			  break;
			}
		}
	}

	if(foundOne)
	{
	  outputImage[threadIndex] = 1;
	}
	else
	{
	  outputImage[threadIndex] = 0;
	}
}

PixelsPtrType Erosion(const PixelsPtrType inputImage, const size_t widthImg, const size_t hightImg, const size_t maskSize)
{
    auto imageSizeBytes = sizeof(PixelType) * widthImg * hightImg;
    auto anglesTableSizeBytes = sizeof(AngleType) * widthImg * hightImg;
    auto blocksNumber = (widthImg * hightImg) / THREAD_NUMBER;
    auto threadsNumber = THREAD_NUMBER;

    gpuErrchk(cudaMemcpy(inputImageDev, inputImage, imageSizeBytes, cudaMemcpyHostToDevice));
    ErosionDev << <blocksNumber, threadsNumber >> > (inputImageDev, widthImg, hightImg, maskSize, outputImageDev);
    gpuErrchk(cudaPeekAtLastError());
    gpuErrchk(cudaDeviceSynchronize());

    auto outputImage = (PixelsPtrType)malloc(sizeof(PixelType) * widthImg * hightImg);

    gpuErrchk(cudaMemcpy(outputImage, outputImageDev, imageSizeBytes, cudaMemcpyDeviceToHost));

	return outputImage;
}

PixelsPtrType Dilation(const PixelsPtrType inputImage, const size_t widthImg, const size_t hightImg, const size_t maskSize)
{
    auto imageSizeBytes = sizeof(PixelType) * widthImg * hightImg;
    auto anglesTableSizeBytes = sizeof(AngleType) * widthImg * hightImg;
    auto blocksNumber = (widthImg * hightImg) / THREAD_NUMBER;
    auto threadsNumber = THREAD_NUMBER;

    gpuErrchk(cudaMemcpy(inputImageDev, inputImage, imageSizeBytes, cudaMemcpyHostToDevice));
    DilationDev << <blocksNumber, threadsNumber >> > (inputImageDev, widthImg, hightImg, maskSize, outputImageDev);
    gpuErrchk(cudaPeekAtLastError());
    gpuErrchk(cudaDeviceSynchronize());

    auto outputImage = (PixelsPtrType)malloc(sizeof(PixelType) * widthImg * hightImg);

    gpuErrchk(cudaMemcpy(outputImage, outputImageDev, imageSizeBytes, cudaMemcpyDeviceToHost));

	return outputImage;
}

PixelsPtrType Opening(const PixelsPtrType inputImage, const size_t widthImg, const size_t hightImg, const size_t maskSize)
{
    auto imageSizeBytes = sizeof(PixelType) * widthImg * hightImg;
    auto anglesTableSizeBytes = sizeof(AngleType) * widthImg * hightImg;
    auto blocksNumber = (widthImg * hightImg) / THREAD_NUMBER;
    auto threadsNumber = THREAD_NUMBER;

    gpuErrchk(cudaMemcpy(inputImageDev, inputImage, imageSizeBytes, cudaMemcpyHostToDevice));
    ErosionDev << <blocksNumber, threadsNumber >> > (inputImageDev, widthImg, hightImg, maskSize, tempImageDev);
    gpuErrchk(cudaPeekAtLastError());
    gpuErrchk(cudaDeviceSynchronize());
    DilationDev << <blocksNumber, threadsNumber >> > (tempImageDev, widthImg, hightImg, maskSize, outputImageDev);
    gpuErrchk(cudaPeekAtLastError());
    gpuErrchk(cudaDeviceSynchronize());

    auto outputImage = (PixelsPtrType)malloc(sizeof(PixelType) * widthImg * hightImg);

    gpuErrchk(cudaMemcpy(outputImage, outputImageDev, imageSizeBytes, cudaMemcpyDeviceToHost));

	return outputImage;
}

PixelsPtrType Closing(const PixelsPtrType inputImage, const size_t widthImg, const size_t hightImg, const size_t maskSize)
{
    auto imageSizeBytes = sizeof(PixelType) * widthImg * hightImg;
    auto anglesTableSizeBytes = sizeof(AngleType) * widthImg * hightImg;
    auto blocksNumber = (widthImg * hightImg) / THREAD_NUMBER;
	auto threadsNumber = THREAD_NUMBER;

    gpuErrchk(cudaMemcpy(inputImageDev, inputImage, imageSizeBytes, cudaMemcpyHostToDevice));
    DilationDev << <blocksNumber, threadsNumber >> > (inputImageDev, widthImg, hightImg, maskSize, tempImageDev);
    gpuErrchk(cudaPeekAtLastError());
    gpuErrchk(cudaDeviceSynchronize());
    ErosionDev << <blocksNumber, threadsNumber >> > (tempImageDev, widthImg, hightImg, maskSize, outputImageDev);
    gpuErrchk(cudaPeekAtLastError());
    gpuErrchk(cudaDeviceSynchronize());

    auto outputImage = (PixelsPtrType)malloc(sizeof(PixelType) * widthImg * hightImg);

    gpuErrchk(cudaMemcpy(outputImage, outputImageDev, imageSizeBytes, cudaMemcpyDeviceToHost));

	return outputImage;
}
