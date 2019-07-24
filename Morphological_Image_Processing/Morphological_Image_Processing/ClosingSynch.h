#pragma once

#include "IMorphologicalOperation.h"
#include "DilationSynch.h"
#include "ErosionSynch.h"
#include "Image.h"

class ClosingSynch : public IMorphologicalOperation
{
public:
	explicit ClosingSynch(const size_t maskSize);
	
public:
	virtual std::shared_ptr<IImage> Process(std::shared_ptr<IImage> image) override;

private:
	size_t _maskSize;

private:
	std::unique_ptr<IMorphologicalOperation> _dilationOperation;
	std::unique_ptr<IMorphologicalOperation> _erosionOperation;
};
