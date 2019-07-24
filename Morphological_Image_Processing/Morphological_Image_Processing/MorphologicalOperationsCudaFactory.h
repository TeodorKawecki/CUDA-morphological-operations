#pragma once

#include "IMorphologicalOperationsFactory.h"

class MorphologicalOperationsCudaFactory : public IMorphologicalOperationsFactory
{
public:
	explicit MorphologicalOperationsCudaFactory(const size_t widthImg, const size_t hightImg, const size_t maskSize);

public:
	virtual std::unique_ptr<IMorphologicalOperation> Create(MorphologicalOperationsTypes type) override;

private:
	size_t _widthImg;
	size_t _hightImg;
	size_t _maskSize;
};
