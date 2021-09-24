
#pragma once

#define __DO_PRAGMA__(X) _Pragma(#X)

#ifdef __clang__
#define __START_IGNORING_WARNINGS__ __DO_PRAGMA__(clang diagnostic push)
#define __STOP_IGNORING_WARNINGS__ __DO_PRAGMA__(clang diagnostic pop)
#define __IGNORE_WARNING__(WARNING) __DO_PRAGMA__(clang diagnostic ignored WARNING)
#else

#ifdef __GNUC__
#define __START_IGNORING_WARNINGS__ __DO_PRAGMA__(GCC diagnostic push)
#define __STOP_IGNORING_WARNINGS__ __DO_PRAGMA__(GCC diagnostic pop)
#define __IGNORE_WARNING__(WARNING) __DO_PRAGMA__(GCC diagnostic ignored WARNING)
#endif

#endif


