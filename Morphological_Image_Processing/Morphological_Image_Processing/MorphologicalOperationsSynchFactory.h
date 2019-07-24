#pragma once

#include "IMorphologicalOperationsFactory.h"

class MorphologicalOperationsSynchFactory : public IMorphologicalOperationsFactory
{
public:
	explicit MorphologicalOperationsSynchFactory(const size_t maskSize);

public:
	virtual std::unique_ptr<IMorphologicalOperation> Create(MorphologicalOperationsTypes type) override;

private:
	size_t _maskSize;
};
