#pragma once

#include "IMorphologicalOperation.h"
#include "Image.h"

class ErosionSynch : public IMorphologicalOperation
{
public:
	explicit ErosionSynch(const size_t maskSize);

public:
	virtual std::shared_ptr<IImage> Process(std::shared_ptr<IImage> image) override;

private:
	size_t _maskSize;
};
