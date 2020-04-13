find_package(Git)

if (Git_FOUND)

function (ADD_GITVERSION_FILE filename)
	add_custom_target(${filename}_gitversion
		COMMAND ${CMAKE_COMMAND} -P "${CMAKE_CURRENT_LIST_DIR}/git-version-runner.cmake"
	)

	add_custom_command(OUTPUT ${filename}
		DEPENDS ${filename}_gitversion
	)
endfunction()

else()
message("git not found!")
endif()
