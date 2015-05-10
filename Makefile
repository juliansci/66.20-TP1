PROG  = tp1
CFLAGS = -g -Wall
DSRC = src/
all: $(PROG)

deleteOld:
	rm $(PROG)

tp1: $(DSRC)main.c $(DSRC)holaMundo.S $(DSRC)printHelp.S $(DSRC)printVersion.S $(DSRC)isEndOfLine.S $(DSRC)strLength.S $(DSRC)concatBuffer.S $(DSRC)tacFile.c $(DSRC)mergeStrings.c
	$(CC) $(CFLAGS) -o $@ $>

clean:
	rm -f $(PROG) *.so *.o *.a *.core
	
permissions:
	chmod +x $(PROG)

