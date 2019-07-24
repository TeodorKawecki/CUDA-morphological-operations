#pragma once

#include "IMorphologicalOperation.h"
#include "DilationSynch.h"
#include "ErosionSynch.h"
#include "Image.h"

class OpeningSynch : public IMorphologicalOperation
{
public:
	explicit OpeningSynch(const size_t maskSize);
	
public:
	virtual std::shared_ptr<IImage> Process(std::shared_ptr<IImage> image) override;

private:
	size_t _maskSize;
	std::unique_ptr<IMorphologicalOperation> _dilationOperation;
	std::unique_ptr<IMorphologicalOperation> _erosionOperation;
};
