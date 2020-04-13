find_package(Git)

if (Git_FOUND)

# Call this function on a target to add version control to said target.
function(TARGET_ADD_GITVERSION target)
	set(prefix args)
	set(flags "")
	set(singleValues WORKING_DIRECTORY)
	set(multiValues "")

	include(CMakeParseArguments)
	cmake_parse_arguments(${prefix} "${flags}" "${singleValues}" "${multiValues}" ${ARGN})
	set(GIT_CMD "${GIT_EXECUTABLE}")
	if (NOT "${args_WORKING_DIRECTORY}" STREQUAL "")
		list(APPEND GIT_CMD "-C ${args_WORKING_DIRECTORY}")
	endif()

	# Processing of git args finished, now turn into actual command
	string(REPLACE ";" " " GIT_CMD "${GIT_CMD}")

	execute_process(COMMAND ${GIT_CMD} log --pretty=format:'%h' -n 1
		OUTPUT_VARIABLE GIT_REV
		ERROR_QUIET
	)

	if ("${GIT_REV}" STREQUAL "")
			set(GIT_REV "N/A")
			set(GIT_DIFF "")
			set(GIT_TAG "N/A")
			set(GIT_BRANCH "N/A")
	else()
		execute_process(COMMAND ${GIT_CMD} diff --shortstat
			OUTPUT_VARIABLE GIT_DIFF)
		if (NOT "${GIT_DIFF}" STREQUAL "")
			set(GIT_DIFF "+")
		endif()

		execute_process(COMMAND ${GIT_CMD} describe -exact-match --tags
			OUTPUT_VARIABLE GIT_TAG ERROR_QUIET)
		execute_process(COMMAND ${GIT_CMD} rev-parse --abbrev-ref HEAD
			OUTPUT_VARIABLE GIT_BRANCH)

		string(STRIP "${GIT_REV}" GIT_REV)
		string(SUBSTRING "${GIT_REV}" 1 7 GIT_REV)
		string(STRIP "${GIT_DIFF}" GIT_DIFF)
		string(STRIP "${GIT_TAG}" GIT_TAG)
		string(STRIP "${GIT_BRANCH}" GIT_BRANCH)
	endif()


set(VERSION
"extern const
struct gitversion
{
	const char* revision;
	const char* branch;
	const char* tag;
} GIT_VERSION{
	.revision = \"${GIT_REV}${GIT_DIFF}\",
	.branch = \"${GIT_BRANCH}\",
	.tag = \"${GIT_TAG}\"
};"
)


	if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/version.cpp)
			file(READ ${CMAKE_CURRENT_SOURCE_DIR}/version.cpp VERSION_)
	else()
			set(VERSION_ "")
	endif()
	if (NOT "${VERSION}" STREQUAL "${VERSION_}")
			file(WRITE ${CMAKE_CURRENT_SOURCE_DIR}/version.cpp "${VERSION}")
	endif()

	message("${GIT_REV}")
	message("${GIT_DIFF}")
	message("${GIT_TAG}")
	message("${GIT_BRANCH}")

	message("${VERSION}")

endfunction()

else()
message("git not found!")
endif()
