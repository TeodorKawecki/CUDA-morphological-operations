#include "DilationSynch.h"

DilationSynch::DilationSynch(const size_t maskSize)
	: _maskSize(maskSize)
{

}

std::shared_ptr<IImage> DilationSynch::Process(std::shared_ptr<IImage> image)
{
	int hightImg = image->GetHight();
	int widthImg = image->GetWidth();
	auto inputImage = image->GetHandle();
	auto outputImage = (PixelsPtrType)malloc(sizeof(PixelType) * image->GetImageSize());

	for (int mainPixelX = 0; mainPixelX < hightImg; ++mainPixelX)
	{
		for (int mainPixelY = 0; mainPixelY < widthImg; ++mainPixelY)
		{
			auto oneDimIndex = mainPixelX * widthImg + mainPixelY;

			int halfSide = (int)((_maskSize - 1) / 2);

			bool foundOne = false;

			for (int row = -halfSide; row <= halfSide && !foundOne; ++row)
			{
				for (int col = -halfSide; col <= halfSide && !foundOne; ++col)
				{
					int currentPixelX = mainPixelX + row;
					int currentPixelY = mainPixelY + col;

					if (currentPixelX < 0)
						currentPixelX = 0;
					if (currentPixelY < 0)
						currentPixelY = 0;
					if (currentPixelX >= hightImg)
						currentPixelX = hightImg - 1;
					if (currentPixelY >= widthImg)
						currentPixelY = widthImg - 1;

					if (inputImage[currentPixelX * widthImg + currentPixelY] > 0)
					{
						foundOne = true;
					}
				}
			}

			if (foundOne)
			{
				outputImage[mainPixelX * widthImg + mainPixelY] = 1;
			}
			else
			{
				outputImage[mainPixelX * widthImg + mainPixelY] = 0;
			}
		}
	}

	return std::make_shared<Image>(outputImage, widthImg, hightImg);
}
