#pragma once

#include <string>
#include "MorphologicalOperationsTypes.h"

struct StartingParameters
{
	std::string inputRelativeFilePath = "";
	std::string outputRelativeFilePath = "default.pbm";
	size_t threshold = 128;
	size_t maskSize = 3;
	MorphologicalOperationsTypes operationType = MorphologicalOperationsTypes::None;
	bool cudaMode = false;
	size_t repeatOperation = 1;
	bool surpressWritingImage = false;
};
