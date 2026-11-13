#include "lib2.h"

#include <cstdlib>
#include <iostream>

#if defined(__has_include)
	#if __has_include(<sanitizer/lsan_interface.h>)
		#include <sanitizer/lsan_interface.h>
		#define HAS_LSAN_HEADER 1
	#endif
#endif
#ifndef HAS_LSAN_HEADER
	#define HAS_LSAN_HEADER 0
#endif

namespace lib2
{
	void ThisViolatesAsanChecks::HeapUseAfterFree()
	{
		int* array = new int[100];
		delete[] array;
		std::cout << array[42] << std::endl;
	}

	void ThisViolatesAsanChecks::StackUseAfterScope()
	{
		int* volatile ptr = nullptr;
		{
			int local[100]{};
			local[42] = 42;
			ptr = &local[0];
		}
		std::cout << ptr[42] << std::endl;
	}

	void ThisViolatesAsanChecks::MemoryLeak()
	{
		{
			void* p = std::malloc(42);
			std::cout << p << std::endl;
			p = nullptr;
			(void) p;
		}
#if HAS_LSAN_HEADER && (defined(__SANITIZE_ADDRESS__) || (defined(__has_feature) && (__has_feature(address_sanitizer) || __has_feature(leak_sanitizer))) || defined(ENABLE_LSAN_CHECK))
		__lsan_do_leak_check();
#endif
	}
}	 // namespace lib2
