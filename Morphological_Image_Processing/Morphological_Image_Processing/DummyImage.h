#pragma once

#include "IImage.h"

class DummyImage : public IImage
{
public:
	DummyImage() = default;

public:
	virtual size_t GetWidth() const override;
	virtual size_t GetHight() const override;
	virtual PixelType operator[](unsigned index) const override;
	virtual PixelsPtrType GetHandle() const override;
	virtual size_t GetImageSize() const override;
};
