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

target_compile_definitions(t1ha PRIVATE T1HA0_RUNTIME_SELECT)
if (HAS_AES_NI)
    if (NOT MSVC)
        target_compile_options(t1ha PRIVATE -maes)
    endif ()
    target_compile_definitions(t1ha PRIVATE T1HA0_AESNI_AVAILABLE)
endif ()

if (MSVC)
    target_compile_options(t1ha PRIVATE /MT /Zi /EHsc)
endif ()
