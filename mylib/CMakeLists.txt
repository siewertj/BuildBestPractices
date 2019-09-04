# Should probably always have this somewhere. You need at least 2.8 for most features
#  but everyone should probably be using above 3.0 at least.
cmake_minimum_required(VERSION 3.6)

# Basically the executable/lib name. Use PROJECT_NAME to access and
#  CMAKE_PROJECT_NAME for the top level project name.
include(version_file)
project(MyProject
	VERSION 0.0.6
)
message("${${PROJECT_NAME}_VERSION}")
set(${PROJECT_NAME}_API
	mylib.h
)

add_library(${PROJECT_NAME} SHARED
	mylib.cpp
	${${PROJECT_NAME}_API}
)

# Always try to use relative paths for anything that will become 'external' linkage to
#  this project. Note that here I'm just assuming that I'll be installing the header
#  into a folder called 'include' but things are not structured that way in my source
#  dir so this generator function fixes that for the install only
target_include_directories(${PROJECT_NAME}
	PUBLIC $<INSTALL_INTERFACE:include>
)


###### INSTALL ######

# This is included to help make package creation easier.
include(CMakePackageConfigHelpers)

# Use the function in the ConfigHelper file to create a version config file
write_basic_package_version_file(
	${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
	VERSION ${${PROJECT_NAME}_VERSION}
	COMPATIBILITY AnyNewerVersion
)


# This installs the project target and exports the project so we can install the targets.cmake
install(TARGETS ${PROJECT_NAME} EXPORT ${PROJECT_NAME}-export
	RUNTIME DESTINATION bin
	LIBRARY DESTINATION lib
	ARCHIVE DESTINATION lib
)

# This installs the targets.cmake file for us.
install(EXPORT ${PROJECT_NAME}-export
	FILE ${PROJECT_NAME}Targets.cmake
	NAMESPACE myproj::
	DESTINATION cmake
)

# install the API header files
install(FILES ${${PROJECT_NAME}_API}
	DESTINATION include/myproj
)

# Finally we need to create/install the config.cmake that we will actually be finding.
#  We need to make sure this goes in a place that the find_package call actually looks
#  for. In this case I'm just putting it in the 'cmake' folder where I'm also putting
#  the Targets.cmake file.
configure_file(Config.cmake.in
	${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
	@ONLY NEWLINE_STYLE LF
)
install(
	FILES
		${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
		${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
	DESTINATION cmake
)

