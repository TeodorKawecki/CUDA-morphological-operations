#include "ClosingCuda.cuh"
#include "Image.h"

ClosingCuda::ClosingCuda(const size_t widthImg, const size_t hightImg, const size_t maskSize)
  :_maskSize(maskSize)
{
	auto imageSizeBytes = sizeof(PixelType) * widthImg * hightImg;
	AllocGpuMemory(imageSizeBytes);
}

ClosingCuda::~ClosingCuda()
{
	FreeGpuMemory();
}

std::shared_ptr<IImage> ClosingCuda::Process(std::shared_ptr<IImage> image)
{
	auto outputImage = Closing(image->GetHandle(), image->GetWidth(), image->GetHight(), _maskSize);

	return std::make_shared<Image>(outputImage, image->GetWidth(), image->GetHight());
}
