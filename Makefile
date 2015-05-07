PROG  = tp1
CFLAGS = -g -Wall
DSRC = src/
all: $(PROG)

tp1: $(DSRC)main.c $(DSRC)holaMundo.S $(DSRC)printHelp.c $(DSRC)printVersion.c $(DSRC)isEndOfLine.S $(DSRC)strLength.c $(DSRC)concatBuffer.c $(DSRC)tacFile.c
	$(CC) $(CFLAGS) -o $@ $>

clean:
	rm -f $(PROG) *.so *.o *.a *.core

