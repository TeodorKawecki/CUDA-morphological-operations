#pragma once

#include <memory>
#include "IImage.h"
#include "Kernels.cuh"
#include "IMorphologicalOperation.h"

class OpeningCuda : public IMorphologicalOperation
{
public:
	explicit OpeningCuda(const size_t widthImg, const size_t hightImg, const size_t maskSize);
	~OpeningCuda();

public:
	virtual std::shared_ptr<IImage> Process(std::shared_ptr<IImage> image) override;

private:
	const size_t _maskSize;
};

