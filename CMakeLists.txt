cmake_minimum_required(VERSION 3.6)
project(BuildBestPractices)

#include (gitversion/FindGitVersion.cmake)
message("${CMAKE_SOURCE_DIR}/gitversion")

set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" "${CMAKE_SOURCE_DIR}/gitversion")
find_package(GitVersion)
#find_package(GitVersion PATHS "${CMAKE_SOURCE_DIR}/gitversion" NO_DEFAULT_PATH)
ADD_GITVERSION_FILE(version.cpp)

add_subdirectory(mylib)
add_executable(foo main.cpp version.cpp)
target_include_directories(foo PRIVATE ${GITVERSION_INCLUDE_DIRECTORIES})
