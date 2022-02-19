
#pragma once

namespace lib3
{
	// non-inclusive set of checks enabled by Ubsan
	struct ThisViolatesUbsanChecks
	{
		void SignedIntegerOverflow();
		void DivideByZero();
	};
} // namespace lib1
