#pragma once

#include<string>
#include<memory>
#include "IImage.h"

using namespace std;

class IImgReader
{
public:
	virtual std::shared_ptr<IImage> ReadImage(const string &filePath) = 0;
};