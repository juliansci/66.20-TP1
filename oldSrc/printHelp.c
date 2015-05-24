#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void printHelp() {
    printf("%s", "Usage:\n");
    printf("%s", "	tp0 -h\n");
    printf("%s", "	tp0 -V\n");
    printf("%s", "	tp0 [file...]\n");
    printf("%s", "Options:\n");
    printf("%s", "	-V, --version Print version and quit.\n");
    printf("%s", "	-h, --help Print this information and quit.\n");
    printf("%s", "Examples:\n");
    printf("%s", "	tp0 foo.txt bar.txt\n");
    printf("%s", "	tp0 gz.txt\n");
}
