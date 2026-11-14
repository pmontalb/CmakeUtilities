#include <gtest/gtest.h>

#include "CudaKernel.h"

#include <cstddef>
#include <vector>

TEST(CudaSmokeTest, VectorAddOnDevice)
{
	if (!libcuda::HasCudaDevice())
		GTEST_SKIP() << "No CUDA GPU available at runtime";

	constexpr size_t kCount = 1025;
	std::vector<float> a(kCount);
	std::vector<float> b(kCount);
	for (size_t i = 0; i < kCount; ++i)
	{
		a[i] = static_cast<float>(i);
		b[i] = static_cast<float>(2U * i + 1U);
	}

	std::vector<float> out;
	ASSERT_TRUE(libcuda::AddVectors(a, b, out));
	ASSERT_EQ(out.size(), kCount);
	for (size_t i = 0; i < kCount; ++i)
		EXPECT_FLOAT_EQ(out[i], static_cast<float>(3U * i + 1U));
}
