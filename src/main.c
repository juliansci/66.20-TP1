#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern void holaMundo();
extern void printHelp();
extern void printVersion();
extern int tacFile(FILE* fp);

int main(int argc, char** argv) {
    
    holaMundo();
    
    if ((argc == 2) && ((strcmp(argv[1], "-h") == 0) || (strcmp(argv[1], "--help") == 0))) {
        printHelp();
        return (EXIT_SUCCESS);
    }

    if ((argc == 2) && ((strcmp(argv[1], "-V") == 0) || (strcmp(argv[1], "--version") == 0))) {
        printVersion();
        return (EXIT_SUCCESS);
    }

    int result;

    if (argc < 2) { //no tengo archivo de entrada, uso standard input
        result = tacFile(stdin);
        return (result);
    }

    int i;
    for (i = 1; i < argc; i++) {
        FILE *fp;
        fp = fopen(argv[i], "r");
        if (fp == NULL) {
            fprintf(stderr, "%s", argv[i]);
            fprintf(stderr, ": nombre de archivo o comando inválido.\n");
            return (EXIT_FAILURE);
        }
        tacFile(fp);
        fclose(fp);
    }
    return (EXIT_SUCCESS);
}