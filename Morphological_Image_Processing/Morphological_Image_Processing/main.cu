#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <chrono>
#include <memory>
#include "IImgReader.h"
#include "OpenCVImageReader.h"
#include "PbmImageWriter.h"
#include "argagg.hpp"
#include "IOHelpers.h"
#include "IMorphologicalOperation.h"
#include "MorphologicalOperationsTypes.h"
#include "IMorphologicalOperationsFactory.h"
#include "MorphologicalOperationsCudaFactory.h"
#include "MorphologicalOperationsSynchFactory.h"
#include "ArgParserWrapper.h"
#include "ArgParserException.h"
#include "DummyImage.h"
#include "ImageIOException.h"

int main(int argc, char **argv)
{
	ArgParserWrapper argParserWrapper;
	StartingParameters startingParameters;

	try
	{
		startingParameters = argParserWrapper.Parse(argc, argv);
	}
	catch (const ArgParserException &ex)
	{
		std::cerr << ex.what();
		return EXIT_FAILURE;
	}

	try
	{
		auto imageReader = std::make_unique<OpenCVImageReader>(startingParameters.threshold);
		auto imageWriter = std::make_unique<PbmImageWriter>();

		auto inputImage = imageReader->ReadImage(IOHelpers::GetExePath() + startingParameters.inputRelativeFilePath);

		std::unique_ptr<IMorphologicalOperationsFactory> morphologicalOperationsFactory = nullptr;

		if (startingParameters.cudaMode)
		{
			morphologicalOperationsFactory = std::make_unique<MorphologicalOperationsCudaFactory>(inputImage->GetWidth(), inputImage->GetHight(), startingParameters.maskSize);
		}
		else
		{
			morphologicalOperationsFactory = std::make_unique<MorphologicalOperationsSynchFactory>(startingParameters.maskSize);
		}

		auto morphologicalOperation = morphologicalOperationsFactory->Create(startingParameters.operationType);

		std::shared_ptr<IImage> outputImage = std::make_shared<DummyImage>();

		for (int i = 0; i < startingParameters.repeatOperation; ++i)
		{
			auto begin = std::chrono::steady_clock::now();
			outputImage = morphologicalOperation->Process(inputImage);
			auto end = std::chrono::steady_clock::now();

			std::cout << std::chrono::duration_cast<std::chrono::milliseconds>(end - begin).count() << std::endl;
		}

		if (!startingParameters.surpressWritingImage)
		{
			imageWriter->WriteImage(IOHelpers::GetExePath() + startingParameters.outputRelativeFilePath, outputImage);
		}
	}
	catch (const ImageIOException &e)
	{
		std::cerr << e.what();
		return EXIT_FAILURE;
	}
	catch (const std::exception &e)
	{
		std::cerr << e.what();
		return EXIT_FAILURE;
	}
	
    return 0;
}
