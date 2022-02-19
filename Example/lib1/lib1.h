
#pragma once

namespace lib1
{
	// non-inclusive set of checks enabled by STL debug
	struct ThisViolatesStlDebugChecks
	{
		void IteratorSanity();
		void AccessOutOfBounds();
		void SortWithNonReflexiveFunction();
	};
} // namespace lib1
