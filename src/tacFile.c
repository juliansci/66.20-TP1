#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int isEndOfLine(char c);
extern char* concatBuffer(char* line, const char* buffer);
extern int printLines(int lineCounter, char ** arrayLines);
extern void *mymalloc(size_t);
extern void myfree(void *);
extern char** resizeArrayLines(char** arrayLines, int arraySize);
extern char** storeNewLine(char lastCharacterBuffer, int* lineCounter, char ** arrayLines, char** line);
extern char *readFile(char *buffer, int n, FILE *stream);


int tacFile(FILE* fp) {
    const int bufIncrSize = 10;
    int lineCounter = 0;
    char** arrayLines = (char**) mymalloc((lineCounter + 1) * sizeof (char *));
    char buffer[bufIncrSize]; //buffer es un array de chars de tamaño 10
    char* line = (char*) mymalloc(1);
    *line = 0;
    while (readFile(buffer, bufIncrSize, fp)) { //lee del archivo de a 10 caracteres o hasta que encuentre fin de linea
        char *newLine = concatBuffer(line, buffer); //le concatena a line el contenido del buffer
        myfree(line);
        line = newLine;
        char lastCharacterBuffer = buffer[strlen(buffer) - 1];
        arrayLines = storeNewLine(lastCharacterBuffer,&lineCounter,arrayLines,&line);
    }

    printLines(lineCounter, arrayLines);
    myfree(line);
    myfree(arrayLines);
    return (EXIT_SUCCESS);
}

