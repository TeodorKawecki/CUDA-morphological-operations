#include "DilationCuda.cuh"
#include "Image.h"

DilationCuda::DilationCuda(const size_t widthImg, const size_t hightImg, const size_t maskSize)
  :_maskSize(maskSize)
{
	auto imageSizeBytes = sizeof(PixelType) * widthImg * hightImg;
	AllocGpuMemory(imageSizeBytes);
}

DilationCuda::~DilationCuda()
{
	FreeGpuMemory();
}

std::shared_ptr<IImage> DilationCuda::Process(std::shared_ptr<IImage> image)
{
	auto outputImage = Dilation(image->GetHandle(), image->GetWidth(), image->GetHight(), _maskSize);

	return std::make_shared<Image>(outputImage, image->GetWidth(), image->GetHight());
}
