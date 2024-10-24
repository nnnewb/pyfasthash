set(
        SMHASHER_SOURCES
        src/smhasher/MurmurHash1.cpp
        src/smhasher/MurmurHash2.cpp
        src/smhasher/MurmurHash3.cpp
        src/smhasher/City.cpp
        src/smhasher/Spooky.cpp
        src/smhasher/SpookyV2.cpp
        src/smhasher/metrohash/metrohash64.cpp
        src/smhasher/metrohash/metrohash128.cpp
)

set(HAS_METRO_HASH_CRC FALSE)
if (HAS_SSE42)
    if ((CMAKE_SIZEOF_VOID_P EQUAL 8 AND NOT MSVC) OR CMAKE_SYSTEM_PROCESSOR MATCHES "^aarch64")
        set(HAS_METRO_HASH_CRC TRUE)
        list(
                APPEND SMHASHER_SOURCES
                src/smhasher/metrohash/metrohash64crc.cpp
                src/smhasher/metrohash/metrohash128crc.cpp
        )
    endif ()
endif ()

add_library(
        smhasher STATIC
        ${SMHASHER_SOURCES}
)

if (HAS_SSE42 AND NOT MSVC)
    target_compile_options(smhasher PRIVATE -msse4.2)
endif ()

set_target_properties(smhasher PROPERTIES CXX_STANDARD 11)
if (MSVC)
    target_compile_options(smhasher PRIVATE /utf-8 /MT /Zi /EHsc)
else ()
    target_compile_options(smhasher PRIVATE -fPIC)
endif ()
