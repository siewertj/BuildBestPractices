cmake_minimum_required(VERSION 3.6)
project(BuildBestPractices)

include (git-version.cmake)
add_subdirectory(mylib)
add_custom_target(foo)
target_add_gitversion(foo)

