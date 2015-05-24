#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern void *mymalloc(size_t);

char* mergeStrings(char* string1, size_t len1, char* string2, size_t len2) {
	char* concat = mymalloc(len1 + len2 + 1);

	int i;
	for (i = 0; i < len1; i++){
		concat[i] = string1[i];
	}

	for (i = 0; i < len2; i++){
		int j = i + len1;
		concat[j] = string2[i];
	}

	concat[len1+len2] = 0;

	return concat;
}
