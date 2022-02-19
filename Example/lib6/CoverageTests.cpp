
#include <gtest/gtest.h>

#include "lib6.h"

class CoverageTest: public ::testing::Test
{
};

TEST_F(CoverageTest, Main)
{
	lib6::CoverageTest coverageTest;
	coverageTest.Main();
}

