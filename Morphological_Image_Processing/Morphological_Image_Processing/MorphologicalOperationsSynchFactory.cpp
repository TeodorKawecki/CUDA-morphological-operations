#include "MorphologicalOperationsSynchFactory.h"
#include "ErosionSynch.h"
#include "DilationSynch.h"
#include "OpeningSynch.h"
#include "ClosingSynch.h"

MorphologicalOperationsSynchFactory::MorphologicalOperationsSynchFactory(const size_t maskSize)
	:_maskSize(maskSize)
{

}

std::unique_ptr<IMorphologicalOperation> MorphologicalOperationsSynchFactory::Create(MorphologicalOperationsTypes type)
{
	switch (type)
	{
		case MorphologicalOperationsTypes::Erosion:
			return std::make_unique<ErosionSynch>(_maskSize);
		case MorphologicalOperationsTypes::Dilation:
			return std::make_unique<DilationSynch>(_maskSize);
		case MorphologicalOperationsTypes::Opening:
			return std::make_unique<OpeningSynch>(_maskSize);
		case MorphologicalOperationsTypes::Closing:
			return std::make_unique<ClosingSynch>(_maskSize);
		default:
			return std::unique_ptr<IMorphologicalOperation>();
	}
}

