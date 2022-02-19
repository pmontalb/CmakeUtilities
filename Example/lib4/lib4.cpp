
#include "lib4.h"

#include <cmath>
#include <iostream>
#include <map>

namespace lib4
{
	using map_t = std::map<std::string, std::string>;

	static inline void *threadfunc(void *p) {
		map_t& m = *static_cast<map_t*>(p);
		m["foo"] = "bar";
		return nullptr;
	}

	void ThisViolatesTsanChecks::DataRace() {
		map_t m;
		pthread_t t;
		pthread_create(&t, nullptr, threadfunc, &m);
		std::cout << "foo=" << m["foo"] << std::endl;
		pthread_join(t, nullptr);
	}

}	 // namespace lib4
