cmake_minimum_required(VERSION 3.16)
project(VS-Compress LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Set the vcpkg installation directory in the project root (not per-build)
set(VCPKG_DIR "${CMAKE_SOURCE_DIR}/out/vcpkg")

# Clone vcpkg if it doesn't exist
if(NOT EXISTS "${VCPKG_DIR}/vcpkg" AND NOT EXISTS "${VCPKG_DIR}/vcpkg.exe")
    message(STATUS "Cloning vcpkg into ${VCPKG_DIR}...")
    execute_process(
        COMMAND git clone https://github.com/microsoft/vcpkg.git "${VCPKG_DIR}"
        RESULT_VARIABLE GIT_CLONE_RESULT
    )
    if(GIT_CLONE_RESULT)
        message(FATAL_ERROR "Failed to clone vcpkg")
    endif()

    message(STATUS "Bootstrapping vcpkg...")
    if(WIN32)
        execute_process(
            COMMAND "${VCPKG_DIR}/bootstrap-vcpkg.bat"
            WORKING_DIRECTORY "${VCPKG_DIR}"
            RESULT_VARIABLE VCPKG_BOOTSTRAP_RESULT
        )
    else()
        execute_process(
            COMMAND "${VCPKG_DIR}/bootstrap-vcpkg.sh"
            WORKING_DIRECTORY "${VCPKG_DIR}"
            RESULT_VARIABLE VCPKG_BOOTSTRAP_RESULT
        )
    endif()
    
    if(VCPKG_BOOTSTRAP_RESULT)
        message(FATAL_ERROR "Failed to bootstrap vcpkg")
    endif()
endif()

# Set the toolchain file after vcpkg is ready
set(CMAKE_TOOLCHAIN_FILE "${VCPKG_DIR}/scripts/buildsystems/vcpkg.cmake" CACHE STRING "")

# Ensure vcpkg installs required dependencies before configuring the project
message(STATUS "Installing dependencies via vcpkg...")
execute_process(
    COMMAND "${VCPKG_DIR}/vcpkg" install --triplet x64-windows
    RESULT_VARIABLE VCPKG_INSTALL_RESULT
)
if(VCPKG_INSTALL_RESULT)
    message(FATAL_ERROR "Failed to install vcpkg dependencies")
endif()

# Set the correct prefix path for finding packages
set(CMAKE_PREFIX_PATH "${CMAKE_SOURCE_DIR}/vcpkg_installed/x64-windows")

# Find dependencies
find_package(TBB CONFIG REQUIRED)
find_package(Eigen3 CONFIG REQUIRED)
find_package(Boost CONFIG REQUIRED)
find_package(PDAL CONFIG REQUIRED)
find_package(ZLIB REQUIRED)

add_executable(vs-compress src/main.cpp)

target_link_libraries(vs-compress PRIVATE 
    TBB::tbb
    TBB::tbbmalloc
    Eigen3::Eigen 
    Boost::boost 
    pdalcpp                 
    ZLIB::ZLIB
)
