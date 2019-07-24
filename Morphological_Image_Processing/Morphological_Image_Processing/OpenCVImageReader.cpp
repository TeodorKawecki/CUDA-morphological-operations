#include "OpenCVImageReader.h"
#include "Image.h"
#include "ImageIOException.h"

using namespace std;
using namespace cv;

OpenCVImageReader::OpenCVImageReader(int threshold)
	: _threshold(threshold)
{
	
}

std::shared_ptr<IImage> OpenCVImageReader::ReadImage(const string &filePath)
{
	Mat image;

	image = imread(filePath, IMREAD_GRAYSCALE);

	if (!image.data)
	{
		throw ImageIOException("Could not open or find image!");
	}

	auto imgWidth = image.cols;
	auto imgHight = image.rows;

	auto pixelsGrayScale = (PixelsPtrType) malloc(sizeof(PixelType) * imgWidth * imgHight);

	for (auto row = 0; row < imgHight; ++row)
	{
		for (auto col = 0; col < imgWidth; ++col)
		{
			auto pixelValue = image.at<uchar>(row, col);

			auto quantizedPixelValue = pixelValue > _threshold ? 1 : 0;

			pixelsGrayScale[row * imgWidth + col] = (PixelType)quantizedPixelValue;
		}
	}

	return std::make_shared<Image>(pixelsGrayScale, imgWidth, imgHight);
}