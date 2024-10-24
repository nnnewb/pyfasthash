cmake_minimum_required(VERSION 3.19)
project(_pyhash2)
find_package(Python3 REQUIRED COMPONENTS Development.Module)

include(cmake/compiler-features.cmake)
include(cmake/fnv.cmake)
include(cmake/farm.cmake)
if (NOT WIN32)
    include(cmake/highway.cmake)
endif ()
include(cmake/lookup3.cmake)
include(cmake/smhasher.cmake)
include(cmake/superfasthash.cmake)
include(cmake/t1ha.cmake)
include(cmake/xxhash.cmake)

set(PYHASH2_SOURCES src/Hash.cpp)
Python3_add_library(${PROJECT_NAME} MODULE ${PYHASH2_SOURCES})
if (MSVC)
    target_compile_options(${PROJECT_NAME} PRIVATE /utf-8 /std:c++14 /EHsc /Zi /MT)
elseif (GNU OR CLANG)
    target_compile_options(${PROJECT_NAME} PRIVATE -std=c++14)
endif ()

target_link_libraries(${PROJECT_NAME} PRIVATE fnv farm lookup3 smhasher SuperFastHash t1ha xxhash)
if (NOT WIN32)
    target_link_libraries(${PROJECT_NAME} PRIVATE highway)
endif ()

if (MSVC)
    target_compile_options(${PROJECT_NAME} PRIVATE /MT /Zi /EHsc)
    target_link_options(${PROJECT_NAME} PRIVATE /OPT:REF /OPT:ICF)
endif ()

if (HAS_AES_NI)
    target_compile_definitions(${PROJECT_NAME} PRIVATE HAS_AES_INST)
endif ()

if (HAS_METRO_HASH_CRC)
    target_compile_definitions(${PROJECT_NAME} PRIVATE SUPPORT_METRO_HASH_CRC=1)
endif ()

if (HAS_INT128 AND NOT MSVC)
    target_compile_options(${PROJECT_NAME} PRIVATE -flax-vector-conversions)
endif ()

target_include_directories(
        ${PROJECT_NAME} PRIVATE
        src/
        src/highwayhash/
        src/pybind11/include/
)
