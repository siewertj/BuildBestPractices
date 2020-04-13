if (NOT "${GIT_CMD}" STREQUAL "")
	execute_process(COMMAND ${GIT_CMD} log --pretty=format:'%h' -n 1
		OUTPUT_VARIABLE GIT_REV
		ERROR_QUIET
	)
endif()

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

#set(VERSION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/${VERSION_FILE}")
if (EXISTS "${VERSION_FILE}")
		file(READ "${VERSION_FILE}" VERSION_)
else()
		set(VERSION_ "")
endif()
if (NOT "${VERSION}" STREQUAL "${VERSION_}")
		file(WRITE "${VERSION_FILE}" "${VERSION}")
endif()

message("${GIT_REV}")
message("${GIT_DIFF}")
message("${GIT_TAG}")
message("${GIT_BRANCH}")

message("created GitVersion file")
