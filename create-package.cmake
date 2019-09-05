set(ManifestFile "install_manifest.txt")
set(RootDir "")

file(STRINGS ${ManifestFile} CONTENTS) 
set(InstallList "")
foreach(filepath ${CONTENTS})
	file(RELATIVE_PATH filepath_rel ${RootDir} ${filepath})
	list(APPEND InstallList ${filepath_rel})
endforeach()

execute_process(
	COMMAND ${CMAKE_COMMAND} -E tar "cvf" "archive.zip" -format=zip -- ${InstallList}
	WORKING_DIR ${InstallDir}
)
