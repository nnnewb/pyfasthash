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

if (CMAKE_SYSTEM_PROCESSOR MATCHES "^aarch64" OR CMAKE_SYSTEM_PROCESSOR MATCHES "(x86|x86_64|i[3-6]86)|amd64|AMD64")
    list(
            APPEND SMHASHER_SOURCES
            src/smhasher/metrohash/metrohash64crc.cpp
            src/smhasher/metrohash/metrohash128crc.cpp
    )
endif ()

add_library(
        smhasher STATIC
        ${SMHASHER_SOURCES}
)

set_target_properties(smhasher PROPERTIES CXX_STANDARD 11)
if (MSVC)
    target_compile_options(smhasher PRIVATE /MT /Zi /EHsc)
endif ()
