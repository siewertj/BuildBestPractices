cmake_minimum_required(VERSION 3.6)
project(BuildBestPractices)

include (git-version.cmake)
add_subdirectory(mylib)

ADD_GITVERSION_FILE(version.cpp)
add_executable(foo main.cpp version.cpp)
