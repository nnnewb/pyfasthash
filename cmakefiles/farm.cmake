add_library(
        farm STATIC
        src/smhasher/farmhash-c.c
)

if (MSVC)
    target_compile_options(farm PRIVATE /MT /Zi /EHsc)
endif ()
