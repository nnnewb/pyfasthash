include(CheckCXXSourceCompiles)
check_cxx_source_compiles(
        "
        #include <immintrin.h>
        int main() {
            __m128i a = _mm_aesenc_si128(_mm_setzero_si128(), _mm_setzero_si128());
            return 0;
        }
        "
        HAS_AES_INSTRUCTION
)

set(
        T1HA_SOURCES
        src/smhasher/t1ha/t1ha0.c
        src/smhasher/t1ha/t1ha0_ia32aes_noavx.c
        src/smhasher/t1ha/t1ha1.c
        src/smhasher/t1ha/t1ha2.c
)

if (HAS_AES_INSTRUCTION)
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
if (HAS_AES_INSTRUCTION)
    target_compile_definitions(t1ha PRIVATE T1HA0_AESNI_AVAILABLE)
endif ()
