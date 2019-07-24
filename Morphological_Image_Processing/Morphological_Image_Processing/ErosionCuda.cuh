#pragma once

#include <memory>
#include "IImage.h"
#include "Kernels.cuh"
#include "IMorphologicalOperation.h"

class ErosionCuda : public IMorphologicalOperation
{
public:
	explicit ErosionCuda(const size_t widthImg, const size_t hightImg, const size_t maskSize);
	~ErosionCuda();

public:
	virtual std::shared_ptr<IImage> Process(std::shared_ptr<IImage> image) override;

private:
	const size_t _maskSize;
};

