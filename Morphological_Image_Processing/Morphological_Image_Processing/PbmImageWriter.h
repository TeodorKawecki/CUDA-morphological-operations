#pragma once

#include "IImgWriter.h"

class PbmImageWriter : public IImgWriter
{
public:
	PbmImageWriter() = default;
	~PbmImageWriter() = default;

public:
	virtual void WriteImage(const string &path, std::shared_ptr<IImage> imagePtr) const override;
};

