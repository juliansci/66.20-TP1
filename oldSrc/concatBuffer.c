#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern size_t strLength(char* c);
extern char* mergeStrings(char* string1, size_t len1, char* string2, size_t len2);

char* concatBuffer(char* line, char* buffer) {
	size_t len1 = 0;
	if (line) {
		len1 = strLength(line);
	}

	size_t len2 = 0;
	if (buffer) {
		len2 = strLength(buffer);
	}

	if (len2 == 0) {
		return line;
	}

	char* concat = mergeStrings(line,len1,buffer,len2);
    return concat;
}

