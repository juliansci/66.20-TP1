PROG  = tp1
CFLAGS = -g -Wall
DSRC = src/
all: $(PROG)

deleteOld:
	rm $(PROG)

tp1: $(DSRC)main.c $(DSRC)printHelp.S $(DSRC)printVersion.S $(DSRC)strLength.S $(DSRC)tacFile.S $(DSRC)printLines.S $(DSRC)resizeArrayLines.S $(DSRC)mymalloc.S $(DSRC)storeNewLine.S $(DSRC)readFile.S $(DSRC)concatByte.S
	$(CC) $(CFLAGS) -o $@ $>

clean:
	rm -f $(PROG) *.so *.o *.a *.core
	
permissions:
	chmod +x $(PROG)

