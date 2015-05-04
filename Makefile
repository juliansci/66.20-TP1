PROG  = tp1
CFLAGS = -g -Wall

all: $(PROG)

tp1: main.c holaMundo.S printHelp.c printVersion.c isEndOfLine.c concatBuffer.c
	$(CC) $(CFLAGS) -o $@ $>

clean:
	rm -f $(PROG) *.so *.o *.a *.core

