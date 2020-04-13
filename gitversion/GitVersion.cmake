message("<-- GitVersion.cmake -->")
find_package(Git)

set(GITVERSION_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}")
set(GITVERSION_INCLUDE_DIRECTORIES "${GITVERSION_DIRECTORY}/include")

function (GITVERSION_ADD_FILE filename)
	set(flags "")
	set(singleValues GIT_REPOSITORY TARGET_NAME)
	set(multiValues "")

	include(CMakeParseArguments)
	cmake_parse_arguments(args "${flags}" "${singleValues}" "${multiValues}" ${ARGN})

	if ("${args_TARGET_NAME}" STREQUAL "")
		set(args_TARGET_NAME "${PROJECT_NAME}_gitversion")
	endif()

	if (NOT IS_ABSOLUTE "${filename}")
		set(filename "${CMAKE_CURRENT_BINARY_DIR}/${filename}")
	endif()

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
	add_custom_target(${args_TARGET_NAME}
		COMMAND ${CMAKE_COMMAND} 
			-D GIT_CMD="${GIT_CMD}"
			-D VERSION_FILE="${filename}"
			-P "${GITVERSION_DIRECTORY}/_GitVersion.cmake"
	)

	# This is essentially a dummy command target so that we can link against the output
	# file. This essentially does nothing (but depends on the dummy target)
	add_custom_command(OUTPUT ${filename}
		DEPENDS ${args_TARGET_NAME}
	)
endfunction()
