#pragma once

#include<string>
#include "IImage.h"

using namespace std;

class IImgWriter
{
public:
	virtual void WriteImage(const string &path, std::shared_ptr<IImage> imagePtr) const = 0;
};
