
#include <gtest/gtest.h>

#include "lib5.h"

class PerformanceTest: public ::testing::Test
{
};

TEST_F(PerformanceTest, Filter)
{
	lib5::LongToRunTest longToRunTest;
	ASSERT_NE(longToRunTest.Filter(), 0.0);
}

TEST_F(PerformanceTest, RandomNumbers)
{
	lib5::LongToRunTest longToRunTest;
	ASSERT_NE(longToRunTest.RandomNumbers(), 0.0);
}

