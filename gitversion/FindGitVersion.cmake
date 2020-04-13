message("----FOUND ME----")
find_package(Git)
message("${CMAKE_CURRENT_LIST_DIR}")

set(GITVERSION_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}")
set(GITVERSION_INCLUDE_DIRECTORIES "${GITVERSION_DIRECTORY}/include")

function (ADD_GITVERSION_FILE filename)
	set(flags "")
	set(singleValues GIT_REPOSITORY)
	set(multiValues "")

	include(CMakeParseArguments)
	cmake_parse_arguments(args "${flags}" "${singleValues}" "${multiValues}" ${ARGN})

	if (Git_FOUND)
		set(GIT_CMD "${GIT_EXECUTABLE}")
		if (NOT "${args_GIT_REPOSITORY}" STREQUAL "")
			list(APPEND GIT_CMD "-C ${args_GIT_REPOSITORY}")
		endif()

		# Processing of git args finished, now turn into actual command
		string(REPLACE ";" " " GIT_CMD "${GIT_CMD}")
	else()
		set(GIT_CMD "")
	endif()

	# This adds the target that is run every time. This is what actually creates the
	# gitversion file. If GIT_CMD is an empty string, then this will take care of it
	# and essentially return a dummy version file
	add_custom_target(${filename}_gitversion
		COMMAND ${CMAKE_COMMAND} 
			-D GIT_CMD="${GIT_CMD}"
			-P "${GITVERSION_DIRECTORY}/_GitVersion.cmake"
	)

	# This is essentially a dummy command target so that we can link against the output
	# file. This essentially does nothing (but depends on the dummy target)
	add_custom_command(OUTPUT ${filename}
		DEPENDS ${filename}_gitversion
	)
endfunction()

find_package_handle_standard_args(GitVersion
	REQUIRED_VARS GITVERSION_INCLUDE_DIRECTORIES
)
