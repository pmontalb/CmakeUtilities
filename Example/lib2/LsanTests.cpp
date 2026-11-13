#include <gtest/gtest.h>

#include "IgnoreWarning.h"
#include "lib2.h"

class LsanTests : public ::testing::Test
{
};

#ifdef __clang__
	#define ASSERT_DEATH_NO_WARNING(...) \
		__START_IGNORING_WARNINGS__ \
		__IGNORE_WARNING__("-Wused-but-marked-unused") \
		__IGNORE_WARNING__("-Wswitch-default") \
		ASSERT_DEATH(__VA_ARGS__) \
		__STOP_IGNORING_WARNINGS__
#else
	#define ASSERT_DEATH_NO_WARNING ASSERT_DEATH
#endif

TEST_F(LsanTests, MemoryLeak)
{
	lib2::ThisViolatesAsanChecks checks;
	ASSERT_DEATH_NO_WARNING(checks.MemoryLeak(), "memory leaks");
}
