#pragma once

#include <span>

namespace libcuda
{
	[[nodiscard]] bool HasCudaDevice() noexcept;
	[[nodiscard]] bool AddVectors(std::span<const float> a, std::span<const float> b, std::span<float> out);
}	 // namespace libcuda
