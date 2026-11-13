#include <gtest/gtest.h>

#include "CoreFeatures.h"

#include <array>

TEST(CoreFeaturesTest, ConceptsAndSpan)
{
	EXPECT_EQ(libcore::Square(7), 49);
	constexpr std::array<std::uint32_t, 4> kMasks{0U, 1U, 3U, 0xFFU};
	EXPECT_EQ(libcore::SumPopcounts(kMasks), 11);
}

TEST(CoreFeaturesTest, CppStandardVersion)
{
	EXPECT_GE(libcore::EvaluateCppVersionFeature(), 2020);
}

TEST(CoreFeaturesTest, MathConsistency)
{
	const double avg = libcore::ComputeStableMath(64);
	EXPECT_NEAR(avg, 1.0, 1e-6);
}
