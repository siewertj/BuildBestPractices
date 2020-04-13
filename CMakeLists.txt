cmake_minimum_required(VERSION 3.6)
project(BuildBestPractices)

include (gitversion/FindGitVersion.cmake)
#find_package(GitVersion)
ADD_GITVERSION_FILE(version.cpp)

add_subdirectory(mylib)
add_executable(foo main.cpp version.cpp)
target_include_directories(foo PRIVATE ${GITVERSION_INCLUDE_DIRECTORIES})
