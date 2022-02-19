
#include "lib5.h"

#include <cmath>
#include <iostream>
#include <map>
#include <random>
#include <chrono>

namespace lib5
{
	double LongToRunTest::Filter()
	{
		constexpr size_t N = 512;
		constexpr size_t M = 1000;

		double ret = 0.0;
		for (size_t m = 0; m < M; ++m)
		{
			std::array<double, N * N> filter;

			std::array<double, N> x;
			for (size_t i = 0; i < N; ++i)
				x[i] = -4.0 + 8.0 * static_cast<double>(i) / (N - 1);

			for (size_t i = 0; i < N; ++i)
			{
				for (size_t j = 0; j < N; ++j)
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
		// initialize the random number generator with time-dependent seed
		const auto timeSeed = static_cast<uint64_t>(std::chrono::high_resolution_clock::now().time_since_epoch().count());
		std::seed_seq ss{uint32_t(timeSeed & 0xffffffff), uint32_t(timeSeed>>32)};
		rng.seed(ss);

		std::uniform_real_distribution<double> uniformRealDistribution(0, 1);

		constexpr size_t N = 1024;

		constexpr size_t M = 100000;

		double ret = 0.0;
		for (size_t m = 0; m < M; ++m)
		{
			std::array<double, N> randomNumbers;
			for (size_t i = 0; i < N; ++i)
				randomNumbers[i] = uniformRealDistribution(rng);

			ret += 1.0 + randomNumbers[N / 2];
		}

		return ret;
	}

}	 // namespace lib5
