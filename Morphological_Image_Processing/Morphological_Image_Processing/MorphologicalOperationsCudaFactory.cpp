#include "MorphologicalOperationsCudaFactory.h"
#include "ErosionCuda.cuh"
#include "DilationCuda.cuh"
#include "OpeningCuda.cuh"
#include "ClosingCuda.cuh"

MorphologicalOperationsCudaFactory::MorphologicalOperationsCudaFactory(const size_t widthImg, const size_t hightImg, const size_t maskSize)
	: _widthImg(widthImg)
	, _hightImg(hightImg)
	, _maskSize(maskSize)
{

}

std::unique_ptr<IMorphologicalOperation> MorphologicalOperationsCudaFactory::Create(MorphologicalOperationsTypes type)
{
	switch (type)
	{
	case MorphologicalOperationsTypes::Erosion:
		return std::make_unique<ErosionCuda>(_widthImg, _hightImg, _maskSize);
	case MorphologicalOperationsTypes::Dilation:
		return std::make_unique<DilationCuda>(_widthImg, _hightImg, _maskSize);
	case MorphologicalOperationsTypes::Opening:
		return std::make_unique<OpeningCuda>(_widthImg, _hightImg, _maskSize);
	case MorphologicalOperationsTypes::Closing:
		return std::make_unique<ClosingCuda>(_widthImg, _hightImg, _maskSize);
	default:
		return std::unique_ptr<IMorphologicalOperation>();
	}
}
