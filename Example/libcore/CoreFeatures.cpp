#include "CoreFeatures.h"

#include <array>
#include <bit>
#include <cmath>
#include <numeric>
#include <ranges>

namespace libcore
{
	int SumPopcounts(std::span<const std::uint32_t> values) noexcept
	{
		int total = 0;
		for (const auto v : values)
			total += std::popcount(v);
		return total;
	}

	int EvaluateCppVersionFeature() noexcept
	{
		constexpr std::array<int, 4> kValues{1, 2, 3, 4};
		int sum = 0;
		for (const int v : kValues | std::views::transform([](int x) noexcept { return Square(x); }))
			sum += v;

		if (sum != 30)
			return 0;

#if __cplusplus > 202302L
		return 2026;
#elif __cplusplus >= 202302L
		if consteval
		{
			return 0;
		}
		else
		{
			const auto swapped = std::byteswap(std::uint16_t{0x1234U});
			return (swapped == 0x3412U) ? 2023 : 0;
		}
#else
		return 2020;
#endif
	}

	double ComputeStableMath(int iterations) noexcept
	{
		double acc = 0.0;
		for (int i = 1; i <= iterations; ++i)
		{
			const double x = static_cast<double>(i) * 0.01;
			acc += std::sin(x) * std::sin(x) + std::cos(x) * std::cos(x);
		}
		return acc / static_cast<double>(iterations > 0 ? iterations : 1);
	}
}	 // namespace libcore
