cmake_minimum_required(VERSION 3.19)
project(_pyhash2)
find_package(Python3 REQUIRED COMPONENTS Development)

include(cmakefiles/fnv.cmake)
include(cmakefiles/farm.cmake)
if (NOT WIN32)
    include(cmakefiles/highway.cmake)
endif ()
include(cmakefiles/lookup3.cmake)
include(cmakefiles/smhasher.cmake)
include(cmakefiles/superfasthash.cmake)
include(cmakefiles/t1ha.cmake)
include(cmakefiles/xxhash.cmake)

message(STATUS "FOUND PYTHON3 ${Python3_EXECUTABLE}")
message(STATUS "FOUND PYTHON3 LIBRARIES ${Python3_LIBRARIES}")

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

target_include_directories(
        ${PROJECT_NAME} PRIVATE
        src/
        src/highwayhash/
        src/pybind11/include/
)
