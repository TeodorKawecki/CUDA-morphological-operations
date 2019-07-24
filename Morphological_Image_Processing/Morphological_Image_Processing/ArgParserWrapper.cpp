#include "ArgParserWrapper.h"
#include "ArgParserException.h"

ArgParserWrapper::ArgParserWrapper()
{
	_argParser = parser
	{
		{
			 {
			   "inputRelativeFilePath", {"-a", "--inputRelativeFilePath"},
			   "Input relative file path.", 1
			 },
			 {
			   "outputRelativeFilePath", {"-b", "--outputRelativeFilePath"},
			   "Output relative file path.", 1
			 },
			 {
			   "cudaMode", {"-c","--cuda"},
			   "Cuda mode (default: off)", 0
			 },
			 {
			   "threshold", {"-d", "--threshold"},
			   "PBM threshold.", 1
			 },
			 {
			   "erosion", {"-e","--erosion"},
			   "Erosion (default: off)", 0
			 },
			 {
			   "dilation", {"-f","--dilation"},
			   "Dilation (default: off)", 0
			 },
			 {
			   "opening", {"-g","--opening"},
			   "Opening (default: off)", 0
			 },
			 {
			   "closing", {"-h","--closing"},
			   "Closing (default: off)", 0
			 },
			 {
			   "repeat", {"-i","--repeat"},
			   "Repeat operation", 1
			 },
			 {
			   "surpressWritingImage", {"-s","--surpressWritingImage"},
			   "Surpress writing image", 0
			 }
		}
	};
}

StartingParameters ArgParserWrapper::Parse(int argc, char ** argv)
{
	argagg::parser_results args;

	try 
	{
		args = _argParser.parse(argc, argv);
	}
	catch (const std::exception& e) 
	{
		throw ArgParserException(e.what());
	}

	StartingParameters startingParameters;

	if (args["inputRelativeFilePath"]) 
		startingParameters.inputRelativeFilePath = args["inputRelativeFilePath"].as<std::string>();

	if (args["outputRelativeFilePath"]) 
		startingParameters.outputRelativeFilePath = args["outputRelativeFilePath"].as<std::string>();

	if (args["threshold"]) 
		startingParameters.threshold = args["threshold"].as<int>();

	if (args["repeat"])
		startingParameters.repeatOperation = args["repeat"].as<size_t>();

	if (args["erosion"])
		startingParameters.operationType = MorphologicalOperationsTypes::Erosion;

	if(args["dilation"])
		startingParameters.operationType = MorphologicalOperationsTypes::Dilation;

	if(args["opening"])
		startingParameters.operationType = MorphologicalOperationsTypes::Opening;

	if(args["closing"])
		startingParameters.operationType = MorphologicalOperationsTypes::Closing;

	if (args["cudaMode"])
		startingParameters.cudaMode = true;

	if (args["surpressWritingImage"])
		startingParameters.surpressWritingImage = true;

	return startingParameters;
}
