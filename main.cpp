#include "gitversion.h"
#include <stdio.h>

int main()
{
	printf("%s - %s - %s - %s\n"
		, GIT_VERSION.revision
		, GIT_VERSION.branch
		, GIT_VERSION.tag
		, GIT_VERSION.build_date
	);
	return 0;
}
