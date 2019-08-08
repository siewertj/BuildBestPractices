project(gtest-download NONE)
include(ExternalProject)

set(_install_dir ${CMAKE_BINARY_DIR}/externals/dist/gtest)

ExternalProject_Add(gtest
	PREFIX ${CMAKE_BINARY_DIR}/externals/gtest
	INSTALL_DIR ${_install_dir}
	CMAKE_ARGS -D CMAKE_INSTALL_PREFIX=${_install_dir}

	GIT_REPOSITORY https://github.com/google/googletest.git
	GIT_TAG release-1.8.1
)

