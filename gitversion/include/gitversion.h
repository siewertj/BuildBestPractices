#pragma once
struct gitversion
{
	const char* revision;
	const char* branch;
	const char* tag;
	const char* build_date;
}

#ifndef GITVERSION_VERSION_COMPILATION_FILE
extern const GIT_VERSION;
#endif
