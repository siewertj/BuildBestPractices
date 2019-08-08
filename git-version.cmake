#find_program(GIT_CMD git)
set(GIT_CMD git)

# Command to possibly get the date
#  git log -1 --format=%cd

execute_process(COMMAND ${GIT_CMD} log --pretty=format:'%h' -n 1
	OUTPUT_VARIABLE GIT_REV
	ERROR_QUIET)

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
"const char* GIT_REV=\"${GIT_REV}${GIT_DIFF}\";
const char* GIT_TAG=\"${GIT_TAG}\";
const char* GIT_BRANCH=\"${GIT_BRANCH}\";")


#if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/version.cpp
	#file(READ ${CMAKE_CURRENT_SOURCE_DIR}/version.cpp VERSION_)
#else()
	#set(VERSION_ "")
#endif()
#if (NOT "${VERSION}" STREQUAL "${VERSION_}")
	#file(WRITE ${CMAKE_CURRENT_SOURCE_DIR}/version.cpp "${VERSION}")
#endif()

message("${GIT_REV}")
message("${GIT_DIFF}")
message("${GIT_TAG}")
message("${GIT_BRANCH}")

message("${VERSION}")

