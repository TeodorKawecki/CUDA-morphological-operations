#pragma once

#include "IImage.h"
#include <memory>

class IMorphologicalOperation
{
public:
	virtual std::shared_ptr<IImage> Process(std::shared_ptr<IImage> image) = 0;
};
