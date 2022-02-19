
#include "lib2.h"

#include <iostream>
#include <sanitizer/lsan_interface.h>

namespace lib2
{
	void ThisViolatesAsanChecks::HeapUseAfterFree()
	{
		int *array = new int[100];
		delete [] array;
		std::cout << array[42] << std::endl;
	}

	void ThisViolatesAsanChecks::StackUseAfterScope()
	{
		int *ptr;
		{
			int local[100];
			ptr = &local[0];
		}
		std::cout << ptr[42] << std::endl;
	}

	void ThisViolatesAsanChecks::MemoryLeak()
	{
		{
			void* p;
			p = std::malloc(42);
			std::cout << p << std::endl;
			p = nullptr;
		}
		__lsan_do_leak_check();
	}
}	 // namespace lib1
