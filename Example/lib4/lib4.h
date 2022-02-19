
#pragma once

namespace lib4
{
	// non-inclusive set of checks enabled by Tsan
	struct ThisViolatesTsanChecks
	{
		void DataRace();
	};
} // namespace lib1
