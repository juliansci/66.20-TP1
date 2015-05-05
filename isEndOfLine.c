#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int isEndOfLine(char c) {
    if (c == '\n') {
    	printf("%s","tengo un salto de linea");
    	printf("el espacio es %d",(int)c);
        return 1;
    }
    return 0;
}
