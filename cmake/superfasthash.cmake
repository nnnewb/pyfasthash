add_library(
        SuperFastHash STATIC
        src/SuperFastHash/SuperFastHash.c
)
if (MSVC)
    target_compile_options(SuperFastHash PRIVATE /MT /Zi /EHsc)
else ()
    target_compile_options(SuperFastHash PRIVATE -fPIC)
endif ()
