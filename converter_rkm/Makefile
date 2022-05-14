# Makefile
TARGET = convert_rkm

CC = gcc
CFLAGS = -Wall


OBJ = $(TARGET).o     

all:$(TARGET)

%.o : %.c
	$(CC) -c $(CFLAGS) $< -o $@ $(LDFLAGS)

$(TARGET): $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS) $(LIBS) $(LDFLAGS)

clean:
	rm -f *.o $(TARGET) 
