#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern size_t strLength(char* c);

void concatBuffer(char** line, char* buffer) {
    size_t len1 = *line ? strlen(*line) : 0;
    size_t len2 = buffer ? strlen(buffer) : 0;
    char* concat = realloc(*line, len1 + len2 + 1); //reserva mas espacio para line, ¿por que mas 1?
    if (concat) {
        memcpy(concat + len1, buffer, len2 + 1); //copia los elementos de buffer a partir del ultimo de line
        *line = concat;
    }
}

