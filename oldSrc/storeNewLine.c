#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern void *mymalloc(size_t);
extern char** resizeArrayLines(char** arrayLines, int arraySize);
extern int isEndOfLine(char c);

char** storeNewLine(char lastCharacterBuffer, int* lineCounter, char ** arrayLines,  char** line) {
	if (isEndOfLine(lastCharacterBuffer)) {
            arrayLines = resizeArrayLines(arrayLines, *lineCounter);
            arrayLines[*lineCounter] = *line;
            *line = (char*) mymalloc(1);
            **line = 0;
	    (*lineCounter)++;
        }
	return arrayLines;
}
