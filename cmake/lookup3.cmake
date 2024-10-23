add_library(
        lookup3 STATIC
        src/lookup3/lookup3.c
)
if (MSVC)
    target_compile_options(lookup3 PRIVATE /MT /Zi /EHsc)
else ()
    target_compile_options(lookup3 PRIVATE -fPIC)
endif ()
