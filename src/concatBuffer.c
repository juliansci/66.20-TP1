#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern size_t strLength(char* c);

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

	char* concat = realloc(line, len1 + len2 + 1); //reserva mas espacio para line, ¿por que mas 1?
    memcpy(concat + len1, buffer, len2 + 1); //copia los elementos de buffer a partir del ultimo de line
    return concat;
}

