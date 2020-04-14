# --- GitVersion ---
#
# The purpose of this file is to help add a build version to a project. This build
# version will be based on the git commit of the last build and will be linked
# into the executable/library. This is not intended to replace a proper versioning
# scheme and instead is meant to suppliment it. The idea is that this would be
# useful between releases when debugging or trying to figure out exactly which
# checkout was used for a specific executable build.
#
# As a quick note, this WILL break any type of scheme that relies on a hash to determine
# if 2 executables are the same. You could probably find some way to hack around it
# but I've really intended this to be the thing that determines which executable
# belongs with which source. The idea to basically compile the version string into
# the exe was that it means we can't end up in some weird in-between version state.
#
# As this version is based on the git repo, anything not in that repo will not be
# detected in the version. If you have an ignored file (or more likely a 3rd party
# library that is not in your repo) then this versioning scheme will not be able
# to tell if it's changed or not. Again, I think you could probably do some stuff
# to make that work, but my thought here is that some other tool should be managing
# that.
#
# This WILL know if the repo is dirty when you try to build. In that case, the version
# string will be whatever is checked out, but with a '+' added to indicate that
# the working directory is not a clean checkout.

message(VERBOSE "<-- GitVersion.cmake -->")
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
