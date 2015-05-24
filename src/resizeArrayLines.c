#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern void *mymalloc(size_t);
extern void myfree(void *);

char** resizeArrayLines(char** arrayLines, int arraySize) {
    int i;
    char** oldArrayLines = arrayLines;
    arrayLines = (char**) mymalloc((arraySize + 1) * sizeof (char*));
    for (i = 0; i < arraySize; i++) {
        arrayLines[i] = oldArrayLines[i];
    }
    myfree(oldArrayLines);
    return arrayLines;
}
