#pragma once

#include <cstdint>
#include <span>

namespace libcore
{
	template <typename T>
	concept Arithmetic = requires(T a, T b) {
		a + b;
		a * b;
	};

	template <Arithmetic T>
	constexpr T Square(T value) noexcept
	{
		return value * value;
	}

	int SumPopcounts(std::span<const std::uint32_t> values) noexcept;
	int EvaluateCppVersionFeature() noexcept;
	double ComputeStableMath(int iterations) noexcept;
}	 // namespace libcore
