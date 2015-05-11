#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int isEndOfLine(char c);
extern char* concatBuffer(char* line, const char* buffer);
extern int printLines(int lineCounter,char ** arrayLines, char* line);

int tacFile(FILE* fp) {
    const int bufIncrSize = 10;
    char ** arrayLines = NULL;
    int lineCounter = 0;
    char buffer[bufIncrSize]; //buffer es un array de chars de tamaño 10
    char* line = (char *) calloc(bufIncrSize, sizeof (char)); //line es un puntero a 10 chars
    while (fgets(buffer, bufIncrSize, fp)) { //lee del archivo de a 10 caracteres o hasta que encuentre fin de linea
        line = concatBuffer(line, buffer); //le concatena a line el contenido del buffer
        char lastCharacterBuffer = buffer[strlen(buffer) - 1];
        if (isEndOfLine(lastCharacterBuffer)) {
            arrayLines = realloc(arrayLines,
                    (lineCounter + 1) * sizeof (char *)); //reserva espacio para una linea mas en arrayLines
            arrayLines[lineCounter] = line; //guarda line en el array
            lineCounter++;
            line = (char *) calloc(bufIncrSize, sizeof (char)); //reinicializa line (seteando la memoria en 0)
        }
    }

    printLines(lineCounter,arrayLines,line);
    return (EXIT_SUCCESS);
}
