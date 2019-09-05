function(create_zip_package)
	set(options )
	set(oneValueArgs OUTFILE)
	set(multiValueArgs )
	cmake_parse_arguments(args "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

	set(ManifestFile "${CMAKE_BINARY_DIR}/install_manifest.txt")
	set(RootDir ${CMAKE_INSTALL_PREFIX})

	file(STRINGS ${ManifestFile} CONTENTS) 
	set(InstallList "")
	foreach(filepath ${CONTENTS})
		file(RELATIVE_PATH filepath_rel ${RootDir} ${filepath})
		list(APPEND InstallList ${filepath_rel})
	endforeach()

	execute_process(
		COMMAND ${CMAKE_COMMAND} -E tar "cvf" ${args_OUTFILE} -format=zip -- ${InstallList}
		WORKING_DIR ${RootDir}
	)
endfunction()
