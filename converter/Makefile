# Makefile
TARGET = convert

CC = gcc
CFLAGS = -Wall
LIBS = -lm


OBJ = $(TARGET).o     \
	microsha.o   

all:$(TARGET)

%.o : %.c
	$(CC) -c $(CFLAGS) $< -o $@ $(LDFLAGS)

$(TARGET): $(OBJ) 
	$(CC) -o $@ $^ $(CFLAGS) $(LIBS) $(LDFLAGS)

clean:
	rm -f *.o $(TARGET)
