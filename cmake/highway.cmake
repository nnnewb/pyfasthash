set(
        HIGHWAYHASH_SOURCES
        src/highwayhash/highwayhash/arch_specific.cc
        src/highwayhash/highwayhash/instruction_sets.cc
        src/highwayhash/highwayhash/os_specific.cc
        src/highwayhash/highwayhash/hh_portable.cc
)

if (CMAKE_SYSTEM_PROCESSOR MATCHES "(x86_64|amd64|AMD64)")
    list(
            APPEND HIGHWAYHASH_SOURCES
            "src/highwayhash/highwayhash/hh_sse41.cc"
            "src/highwayhash/highwayhash/hh_avx2.cc"
    )
elseif (CMAKE_SYSTEM_PROCESSOR MATCHES "ppc64")
    list(
            APPEND HIGHWAYHASH_SOURCES
            "src/highwayhash/highwayhash/hh_vsx.cc"
    )
endif ()

add_library(highway STATIC ${HIGHWAYHASH_SOURCES})
target_include_directories(
        highway PRIVATE
        src/highwayhash
)

target_compile_options(highway PRIVATE -fPIC)
if (CMAKE_SYSTEM_PROCESSOR MATCHES "(x86_64|amd64|AMD64)")
    target_compile_options(highway PRIVATE -msse4.1 -mavx2)
elseif (CMAKE_SYSTEM_PROCESSOR MATCHES "arm")
    target_compile_options(highway PRIVATE -march=armv7-a -mfloat-abi=hard -mfpu=neon)
elseif (CMAKE_SYSTEM_PROCESSOR MATCHES "ppc64")
    target_compile_options(highway PRIVATE -mvsx)
endif ()
