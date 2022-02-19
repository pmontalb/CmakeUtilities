
#pragma once

namespace lib2
{
	// non-inclusive set of checks enabled by Asan
	struct ThisViolatesAsanChecks
	{
		void HeapUseAfterFree();
		void StackUseAfterScope();
		void MemoryLeak();
	};
} // namespace lib1
