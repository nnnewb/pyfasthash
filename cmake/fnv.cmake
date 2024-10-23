add_library(
        fnv STATIC
        src/fnv/hash_32.c
        src/fnv/hash_32a.c
        src/fnv/hash_64.c
        src/fnv/hash_64a.c
)
if (MSVC)
    target_compile_options(fnv PRIVATE /utf-8 /MT /Zi /EHsc)
else ()
    target_compile_options(fnv PRIVATE -fPIC)
endif ()
