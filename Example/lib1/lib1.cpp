
#include "lib1.h"

#include <algorithm>
#include <iostream>
#include <vector>

namespace lib1
{
	void ThisViolatesStlDebugChecks::IteratorSanity()
	{
		std::vector<double> x(10);
		std::vector<double> y(10);

		if (x.begin() == y.end())
		{
			std::cout << "WARNING: this should never be the case" << std::endl;
		}
		else
		{
			std::cout << x[0] << std::endl;
			std::cout << y[0] << std::endl;
		}
	}

	void ThisViolatesStlDebugChecks::AccessOutOfBounds()
	{
		std::vector<double> x(10);
		std::vector<double> y(10);

		std::cout << x[x.size() + 1] << std::endl;
		std::cout << y[y.size() + 1] << std::endl;
	}

	void ThisViolatesStlDebugChecks::SortWithNonReflexiveFunction()
	{
		std::vector<double> x(10);
		for (size_t i = 0; i < x.size(); ++i)
			x[i] = static_cast<double>(x.size() - i) * 0.5;

		std::sort(x.begin(), x.end(), [](const auto /*a*/, const auto /*b*/) { return true; });
	}
}	 // namespace lib1
