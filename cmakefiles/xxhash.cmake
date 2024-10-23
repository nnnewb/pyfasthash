add_library(xxhash STATIC src/xxHash/xxhash.c)
if (MSVC)
    target_compile_options(xxhash PRIVATE /utf-8)
endif ()
