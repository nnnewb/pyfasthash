include(CheckCXXSourceCompiles)
check_cxx_source_compiles(
        "
        #include <immintrin.h>
        int main() {
            __m128i a = _mm_aesenc_si128(_mm_setzero_si128(), _mm_setzero_si128());
            return 0;
        }
        "
        HAS_AES_NI
)
if (HAS_AES_NI)
        message(STATUS "build with AES-NI enabled")
endif ()

check_cxx_source_compiles(
        "
        #include <nmmintrin.h>
        int main() {
            unsigned int a = 1, b = 2;
            return _mm_crc32_u32(a, b);
        }
        "
        HAS_SSE42
)
if (HAS_SSE42)
        message(STATUS "build with SSE4.2 enabled")
endif ()

check_cxx_source_compiles(
        "
                #ifdef __SIZEOF_INT128__
                int main(void) { return 0; }
                #else
                #error __SIZEOF_INT128__ is not defined
                #endif
        "
        HAS_INT128
)
if (HAS_INT128)
        message(STATUS "build with __int128 enabled")
endif ()
