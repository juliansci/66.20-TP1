#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char* mergeStrings(char* string1, size_t len1, char* string2, size_t len2) {
	char* concat = realloc(string1, len1 + len2 + 1);
    memcpy(concat + len1, string2, len2 + 1);
    return concat;
}
