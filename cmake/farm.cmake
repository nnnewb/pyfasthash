add_library(
        farm STATIC
        src/smhasher/farmhash-c.c
)

if (MSVC)
    target_compile_options(farm PRIVATE /utf-8 /MT /Zi /EHsc)
else ()
    target_compile_options(farm PRIVATE -fPIC)
endif ()
