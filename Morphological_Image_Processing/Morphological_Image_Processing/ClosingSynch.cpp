#include "ClosingSynch.h"
#include <memory>

ClosingSynch::ClosingSynch(const size_t maskSize)
	: _maskSize(maskSize)
	, _dilationOperation(std::make_unique<DilationSynch>(maskSize))
	, _erosionOperation(std::make_unique<ErosionSynch>(maskSize))
{

}

std::shared_ptr<IImage> ClosingSynch::Process(std::shared_ptr<IImage> image)
{
	auto imageAfterDilation = _dilationOperation->Process(image);

	return _erosionOperation->Process(imageAfterDilation);
}
