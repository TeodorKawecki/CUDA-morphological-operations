#pragma once

#include "IImgReader.h"
#include "IImgWriter.h"
#include "IImage.h"
#include <iostream>
#include <memory>
#include <opencv2/opencv.hpp>

class OpenCVImageReader : public IImgReader
{
public:
	explicit OpenCVImageReader(int threshold);

public:
	virtual std::shared_ptr<IImage> ReadImage(const string &filePath) override;

private:
	int _threshold;
};


