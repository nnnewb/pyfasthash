set(
        T1HA_SOURCES
        src/smhasher/t1ha/t1ha0.c
        src/smhasher/t1ha/t1ha0_ia32aes_noavx.c
        src/smhasher/t1ha/t1ha1.c
        src/smhasher/t1ha/t1ha2.c
)

if (HAS_AES_NI)
    list(
            APPEND T1HA_SOURCES
            src/smhasher/t1ha/t1ha0_ia32aes_avx.c
            src/smhasher/t1ha/t1ha0_ia32aes_avx2.c
    )
endif ()

add_library(
        t1ha STATIC
        ${T1HA_SOURCES}
)

target_compile_definitions(t1ha PUBLIC T1HA0_RUNTIME_SELECT=1)
if (HAS_AES_NI)
    target_compile_definitions(t1ha PUBLIC T1HA0_AESNI_AVAILABLE=1)
    if (NOT MSVC)
        target_compile_options(t1ha PRIVATE -maes)
    endif ()
else ()
    target_compile_definitions(t1ha PUBLIC T1HA0_AESNI_AVAILABLE=0)
endif ()

if (MSVC)
    target_compile_options(t1ha PRIVATE /utf-8 /MT /Zi /EHsc)
else ()
    target_compile_options(t1ha PRIVATE -fPIC)
endif ()
