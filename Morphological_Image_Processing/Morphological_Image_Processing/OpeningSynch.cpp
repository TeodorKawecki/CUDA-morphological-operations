#include "OpeningSynch.h"
#include <memory>

OpeningSynch::OpeningSynch(const size_t maskSize)
	: _maskSize(maskSize)
	, _dilationOperation(std::make_unique<DilationSynch>(maskSize))
	, _erosionOperation(std::make_unique<ErosionSynch>(maskSize))
{

}

std::shared_ptr<IImage> OpeningSynch::Process(std::shared_ptr<IImage> image)
{
	auto imageAfterErosion = _erosionOperation->Process(image);

	return _dilationOperation->Process(imageAfterErosion);
}
