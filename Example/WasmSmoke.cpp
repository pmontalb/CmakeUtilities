#include "CoreFeatures.h"
#include "lib1/lib1.h"
#include "lib3/lib3.h"
#include "lib5/lib5.h"
#include "lib6/lib6.h"

#include <array>
#include <iostream>

int main()
{
	constexpr std::array<std::uint32_t, 3> kMasks{1U, 3U, 7U};
	if (libcore::SumPopcounts(kMasks) != 6)
		return 1;
	if (libcore::EvaluateCppVersionFeature() < 2020)
		return 2;
	if (libcore::ComputeStableMath(10) <= 0.0)
		return 3;

	lib6::CoverageTest cov;
	cov.Main();

	lib5::LongToRunTest perf;
	if (perf.Filter() <= 0.0)
		return 4;

	std::cout << "wasm_smoke OK (C++ standard tag=" << libcore::EvaluateCppVersionFeature() << ")\n";
	return 0;
}
