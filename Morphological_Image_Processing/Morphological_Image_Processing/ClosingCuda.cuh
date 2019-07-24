#pragma once

#include <memory>
#include "IImage.h"
#include "Kernels.cuh"
#include "IMorphologicalOperation.h"

class ClosingCuda : public IMorphologicalOperation
{
public:
	explicit ClosingCuda(const size_t widthImg, const size_t hightImg, const size_t maskSize);
	~ClosingCuda();

public:
	virtual std::shared_ptr<IImage> Process(std::shared_ptr<IImage> image) override;

private:
	const size_t _maskSize;
};

