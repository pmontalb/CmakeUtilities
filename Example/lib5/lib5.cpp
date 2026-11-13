
#include "lib5.h"

#include <array>
#include <chrono>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <iostream>
#include <map>
#include <random>
#include <vector>

namespace lib5
{
	double LongToRunTest::Filter()
	{
		constexpr std::size_t N = 128;
		constexpr std::size_t M = 200;

		double ret = 0.0;
		for (std::size_t m = 0; m < M; ++m)
		{
			std::vector<double> filter(N * N);

			std::array<double, N> x{};
			for (std::size_t i = 0; i < N; ++i)
				x[i] = -4.0 + 8.0 * static_cast<double>(i) / static_cast<double>(N - 1);

			for (std::size_t i = 0; i < N; ++i)
			{
				for (std::size_t j = 0; j < N; ++j)
				{
					const auto dx = (x[i] - x[j]);
					filter[j + i * N] = std::exp(-4.0 * dx * dx);
				}
			}

			ret += 1.0 + filter[N / 2];
		}
		return ret;
	}

	double LongToRunTest::RandomNumbers()
	{
		std::mt19937_64 rng;
		const auto timeSeed = static_cast<std::uint64_t>(std::chrono::high_resolution_clock::now().time_since_epoch().count());
		std::seed_seq ss{static_cast<std::uint32_t>(timeSeed & 0xffffffffULL), static_cast<std::uint32_t>(timeSeed >> 32U)};
		rng.seed(ss);

		std::uniform_real_distribution<double> uniformRealDistribution(0.0, 1.0);

		constexpr std::size_t N = 256;
		constexpr std::size_t M = 5000;

		double ret = 0.0;
		for (std::size_t m = 0; m < M; ++m)
		{
			std::array<double, N> randomNumbers{};
			for (std::size_t i = 0; i < N; ++i)
				randomNumbers[i] = uniformRealDistribution(rng);

			ret += 1.0 + randomNumbers[N / 2];
		}

		return ret;
	}

}	 // namespace lib5
