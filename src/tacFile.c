#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int isEndOfLine(char c);
extern void concatBuffer(char** line, const char* buffer);


int tacFile(FILE* fp) {
    const int bufIncrSize = 10;
    char ** arrayLines = NULL;
    int lineCounter = 0;
    char buffer[bufIncrSize];
    char* line = (char *) calloc(bufIncrSize, sizeof (char));
    while (fgets(buffer, bufIncrSize, fp)) {
        concatBuffer(&line, buffer);
        char lastCharacterBuffer = buffer[strlen(buffer) - 1];
        if (isEndOfLine(lastCharacterBuffer)) {
        	//printf("%c %s",lastCharacterBuffer," es un salto de linea");
            arrayLines = realloc(arrayLines,
                    (lineCounter + 1) * sizeof (char *));
            arrayLines[lineCounter] = line;
            lineCounter++;
            line = (char *) calloc(bufIncrSize, sizeof (char));
        }
    }

    int i;
    for (i = lineCounter - 1; i >= 0; i--) {
        printf("%s", arrayLines[i]);
        free(arrayLines[i]);

    }
    free(line);
    free(arrayLines);
    return (EXIT_SUCCESS);
}
