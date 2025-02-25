cmake_minimum_required(VERSION 3.16)
project(VS-Compress LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Ensure vcpkg toolchain is correctly set
if(DEFINED ENV{VCPKG_ROOT})
    set(CMAKE_TOOLCHAIN_FILE "$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake" CACHE STRING "")
    message(STATUS "Using vcpkg toolchain: ${CMAKE_TOOLCHAIN_FILE}")
endif()

# Find dependencies installed via vcpkg
find_package(TBB CONFIG REQUIRED)
find_package(Eigen3 CONFIG REQUIRED)
find_package(Boost CONFIG REQUIRED)
find_package(PDAL CONFIG REQUIRED)
find_package(ZLIB REQUIRED)

# Add executable target
add_executable(vs-compress src/main.cpp)

# Link dependencies
target_link_libraries(vs-compress PRIVATE 
    TBB::tbb                 
    Eigen3::Eigen 
    Boost::boost 
    pdalcpp                  
    ZLIB::ZLIB
)
