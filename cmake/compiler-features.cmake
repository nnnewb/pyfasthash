# Test compiler SIMD intrinsics support
include(CheckCXXSourceCompiles)

if (NOT MSVC)
    set(CMAKE_REQUIRED_FLAGS "-maes")
endif ()
check_cxx_source_compiles(
        "
        #include <wmmintrin.h>
        int main() {
            __m128i a = _mm_aesenc_si128(_mm_setzero_si128(), _mm_setzero_si128());
            return 0;
        }
        "
        HAS_AES_NI
)

if (NOT MSVC)
    set(CMAKE_REQUIRED_FLAGS "-msse4.2")
endif ()
check_cxx_source_compiles(
        "
        #include <nmmintrin.h>
        int main() {
            unsigned int a = 1, b = 2;
            _mm_crc32_u32(a, b);
            return 0;
        }
        "
        HAS_SSE42
)

if (NOT MSVC)
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
else ()
    # MSVC does not support __int128 non-standard extension
    set(HAS_INT128 FALSE)
endif ()
