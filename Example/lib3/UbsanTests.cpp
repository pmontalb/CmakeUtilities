
#include <gtest/gtest.h>

#include "IgnoreWarning.h"
#include "lib3.h"

class UbsanTests: public ::testing::Test
{
};

#ifdef __clang__
	#define ASSERT_DEATH_NO_WARNING(...)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            \
		__START_IGNORING_WARNINGS__                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            \
		__IGNORE_WARNING__("-Wused-but-marked-unused")                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         \
		ASSERT_DEATH(__VA_ARGS__)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           \
		__STOP_IGNORING_WARNINGS__
#else
	#define ASSERT_DEATH_NO_WARNING ASSERT_DEATH
#endif

TEST_F(UbsanTests, SignedIntegerOverflow)
{
	lib3::ThisViolatesUbsanChecks thisViolatesUbsanChecks;
	ASSERT_DEATH_NO_WARNING(thisViolatesUbsanChecks.SignedIntegerOverflow(), "signed integer overflow");
}

TEST_F(UbsanTests, DivideByZero)
{
	lib3::ThisViolatesUbsanChecks thisViolatesUbsanChecks;
	ASSERT_DEATH_NO_WARNING(thisViolatesUbsanChecks.DivideByZero(), "division by zero");
}
