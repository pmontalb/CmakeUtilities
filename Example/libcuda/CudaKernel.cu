#include "CudaKernel.h"

#include <cuda_runtime.h>

#include <cstddef>

namespace
{
	__global__ void AddKernel(const float* a, const float* b, float* out, const size_t count)
	{
		const size_t idx = static_cast<size_t>(blockIdx.x) * static_cast<size_t>(blockDim.x) + static_cast<size_t>(threadIdx.x);
		if (idx < count)
			out[idx] = a[idx] + b[idx];
	}

	bool FreeBuffers(float* devA, float* devB, float* devOut) noexcept
	{
		if (devA != nullptr)
			cudaFree(devA);
		if (devB != nullptr)
			cudaFree(devB);
		if (devOut != nullptr)
			cudaFree(devOut);
		return false;
	}
}	 // namespace

namespace libcuda
{
	bool HasCudaDevice() noexcept
	{
		int count = 0;
		const cudaError_t err = cudaGetDeviceCount(&count);
		return err == cudaSuccess && count > 0;
	}

	bool AddVectors(const std::span<const float> a, const std::span<const float> b, const std::span<float> out)
	{
		if (a.size() != b.size() || a.size() != out.size())
			return false;

		const size_t count = a.size();
		if (count == 0)
			return true;

		const size_t bytes = count * sizeof(float);
		float* devA = nullptr;
		float* devB = nullptr;
		float* devOut = nullptr;

		if (cudaMalloc(&devA, bytes) != cudaSuccess ||
			cudaMalloc(&devB, bytes) != cudaSuccess ||
			cudaMalloc(&devOut, bytes) != cudaSuccess)
		{
			return FreeBuffers(devA, devB, devOut);
		}

		if (cudaMemcpy(devA, a.data(), bytes, cudaMemcpyHostToDevice) != cudaSuccess ||
			cudaMemcpy(devB, b.data(), bytes, cudaMemcpyHostToDevice) != cudaSuccess)
		{
			return FreeBuffers(devA, devB, devOut);
		}

		constexpr unsigned int kThreadsPerBlock = 256;
		const unsigned int blocks = static_cast<unsigned int>((count + kThreadsPerBlock - 1) / kThreadsPerBlock);
		AddKernel<<<blocks, kThreadsPerBlock, 0, cudaStreamPerThread>>>(devA, devB, devOut, count);

		if (cudaGetLastError() != cudaSuccess || cudaDeviceSynchronize() != cudaSuccess)
			return FreeBuffers(devA, devB, devOut);

		if (cudaMemcpy(out.data(), devOut, bytes, cudaMemcpyDeviceToHost) != cudaSuccess)
			return FreeBuffers(devA, devB, devOut);

		cudaFree(devA);
		cudaFree(devB);
		cudaFree(devOut);
		return true;
	}
}	 // namespace libcuda
