TARGET = acc2tax

CC = cc

CFLAGS = -Wall
#CFLAGS = -Wall -Wextra

.PHONY = default all clean

default : $(TARGET)

all: default

OBJECTS = $(patsubst %.c, %.o, $(wildcard *.c))

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@ 

acc2tax : $(OBJECTS)
	$(CC) $(OBJECTS) -o $@

clean :
	-rm -f *.o
	-rm -f $(TARGET)

