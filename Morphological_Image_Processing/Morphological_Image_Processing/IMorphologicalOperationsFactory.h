#pragma once

#include <memory>
#include "IMorphologicalOperation.h"
#include "MorphologicalOperationsTypes.h"

class IMorphologicalOperationsFactory
{
public:
	virtual std::unique_ptr<IMorphologicalOperation> Create(MorphologicalOperationsTypes type) = 0;
};
