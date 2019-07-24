#include "OpeningCuda.cuh"
#include "Image.h"

OpeningCuda::OpeningCuda(const size_t widthImg, const size_t hightImg, const size_t maskSize)
  :_maskSize(maskSize)
{
	auto imageSizeBytes = sizeof(PixelType) * widthImg * hightImg;
	AllocGpuMemory(imageSizeBytes);
}

OpeningCuda::~OpeningCuda()
{
	FreeGpuMemory();
}

std::shared_ptr<IImage> OpeningCuda::Process(std::shared_ptr<IImage> image)
{
	auto outputImage = Opening(image->GetHandle(), image->GetWidth(), image->GetHight(), _maskSize);

	return std::make_shared<Image>(outputImage, image->GetWidth(), image->GetHight());
}
