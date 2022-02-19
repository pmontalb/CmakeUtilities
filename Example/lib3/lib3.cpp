
#include "lib3.h"

#include <iostream>
#include <cmath>

namespace lib3
{
	void ThisViolatesUbsanChecks::SignedIntegerOverflow()
	{
		int k = 0x7fffffff;
		k += 42;
		std::cout << k << std::endl;
	}

	void ThisViolatesUbsanChecks::DivideByZero()
	{
		double x = 3.14;
		x /= std::sin(0.0);
		std::cout << x << std::endl;
	}

}	 // namespace lib3
