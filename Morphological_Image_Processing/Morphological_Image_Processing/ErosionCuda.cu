#include "ErosionCuda.cuh"
#include "Image.h"

ErosionCuda::ErosionCuda(const size_t widthImg, const size_t hightImg, const size_t maskSize)
  :_maskSize(maskSize)
{
	auto imageSizeBytes = sizeof(PixelType) * widthImg * hightImg;
	AllocGpuMemory(imageSizeBytes);
}

ErosionCuda::~ErosionCuda()
{
	FreeGpuMemory();
}

std::shared_ptr<IImage> ErosionCuda::Process(std::shared_ptr<IImage> image)
{
	auto outputImage = Erosion(image->GetHandle(), image->GetWidth(), image->GetHight(), _maskSize);

	return std::make_shared<Image>(outputImage, image->GetWidth(), image->GetHight());
}
