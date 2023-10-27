cmake_minimum_required(VERSION 3.26)
if(NOT EXISTS "${VCPKG_ROOT}")
    message(FATAL_ERROR "Please run with -DVCPKG_ROOT=<vcpkg-root> ${VCPKG_ROOT} not found")
endif()

include(${CMAKE_CURRENT_LIST_DIR}/../../cmake/BuildEnv.cmake)

include(${VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake)
message(STATUS " 
    CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}
    CMAKE_LIBRARY_PATH: ${CMAKE_LIBRARY_PATH}
    CMAKE_FIND_ROOT_PATH: ${CMAKE_FIND_ROOT_PATH}
    VCPKG_CMAKE_FIND_ROOT_PATH: ${VCPKG_CMAKE_FIND_ROOT_PATH}
    VCPKG_TARGET_TRIPLET: ${VCPKG_TARGET_TRIPLET}
    VCPKG_HOST_TRIPLET: ${VCPKG_HOST_TRIPLET}
")

project(lexyacc-test VERSION 0.0.1)

set(CMAKE_CXX_STANDARD 20)
EnableStrictCompilation()
#set(CMAKE_FIND_DEBUG_MODE TRUE)

find_package(LexYacc REQUIRED)
add_executable(lexyacctest main.cpp)

add_lexyacc_library(TARGET WavefrontObj LYFILE WavefrontObj.ly)
target_include_directories(WavefrontObj PRIVATE .)
target_include_directories(lexyacctest PRIVATE .)

enable_testing()
add_test(NAME lexyacctest COMMAND lexyacctest)
