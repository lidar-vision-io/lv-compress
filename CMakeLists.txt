cmake_minimum_required(VERSION 3.16)
project(VS-Compress LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Using system-wide vcpkg toolchain
if(DEFINED ENV{VCPKG_ROOT})
    set(CMAKE_TOOLCHAIN_FILE "$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake" CACHE STRING "")
endif()

find_package(TBB REQUIRED)
find_package(Eigen3 REQUIRED)
find_package(Boost REQUIRED)
find_package(PDAL REQUIRED)

# Define the source files
add_executable(vs-compress src/main.cpp)

# Link dependencies
target_link_libraries(vs-compress PRIVATE TBB::TBB Eigen3::Eigen Boost::boost PDAL)
