cmake_minimum_required(VERSION 3.6)
project(BuildBestPractices)

include(${CMAKE_SOURCE_DIR}/gitversion/GitVersion.cmake)

GITVERSION_ADD_FILE(generated/version.cpp)

add_subdirectory(mylib)
add_executable(foo main.cpp generated/version.cpp)
target_include_directories(foo PRIVATE ${GITVERSION_INCLUDE_DIRECTORIES})
