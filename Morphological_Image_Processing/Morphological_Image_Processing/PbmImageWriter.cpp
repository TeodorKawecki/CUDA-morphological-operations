#include "PbmImageWriter.h"
#include "ImageIOException.h"
#include <fstream>

void PbmImageWriter::WriteImage(const string &path, std::shared_ptr<IImage> imagePtr) const
{
	ofstream pgmImage;

	try
	{
		pgmImage.open(path, ios::trunc);
	}
	catch (const ios::ios_base::failure &exception)
	{
		throw ImageIOException("Could not open file to write!");
	}

	pgmImage << "P1\n";

	auto imageWidth = imagePtr->GetWidth();
	auto imageHight = imagePtr->GetHight();

	pgmImage << imageWidth << " " << imageHight <<"\n";

	for (int i = 0; i < imageWidth * imageHight; i++)
	{
		pgmImage << (*imagePtr)[i] << " ";
	}

	pgmImage.close();
}
