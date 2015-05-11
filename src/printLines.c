#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int printLines(int lineCounter,char ** arrayLines, char* line){
    int i;
    for (i = lineCounter - 1; i >= 0; i--) {
        printf("%s", arrayLines[i]);
        free(arrayLines[i]);

    }
    free(line);
    free(arrayLines);
    return 0;
}
