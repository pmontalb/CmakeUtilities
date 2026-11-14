#pragma once

#include <span>
#include <vector>

namespace libcuda
{
	[[nodiscard]] bool HasCudaDevice() noexcept;
	[[nodiscard]] bool AddVectors(std::span<const float> a, std::span<const float> b, std::vector<float>& out);
}	 // namespace libcuda
