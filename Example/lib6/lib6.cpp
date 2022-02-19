
#include "lib6.h"

#include <cmath>
#include <iostream>
#include <map>
#include <random>
#include <chrono>

namespace lib6
{
	void CoverageTest::Main()
	{
		F1();
		F2();
		F3();
		F4();

		bool condition = false;
		if (condition)
			F1();
		condition = true;
		if (condition)
			F2();
	}

	void CoverageTest::F1()
	{
		bool condition = false;
		if (condition)
			std::cout << "F1: true" << std::endl;
		else
			std::cout << "F1: false" << std::endl;
	}

	void CoverageTest::F2()
	{
		bool condition = true;
		if (condition)
			std::cout << "F2: true" << std::endl;
		else
			std::cout << "F2: false" << std::endl;
	}

	void CoverageTest::F3()
	{
		bool condition = true;
		std::cout << (condition ? ("F2: true") : ("F2: false")) << std::endl;

		condition = false;
		std::cout << (condition ? ("F2: true") : ("F2: false")) << std::endl;
	}
	void CoverageTest::F4()
	{
		std::cout << "F4: true" << std::endl;
	}
}	 // namespace lib5
