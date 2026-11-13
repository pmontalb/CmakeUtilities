#include <cstdio>
#include <cstring>

int main(int argc, char** argv)
{
	volatile int buffer[2];
	buffer[0] = 42;
	if (argc > 1 && std::strcmp(argv[1], "fail") == 0)
	{
		if (buffer[1] == 0)
			return 1;
	}
	std::printf("MSan clean check: %d\n", buffer[0]);
	return 0;
}
