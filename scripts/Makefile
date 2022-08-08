# Makefile

.PHONY: clean  all convert_music convert_pgm

all: convert_pgm convert_music

convert_pgm: convert_pgm.py logo_undefined.pgm
	python3.8 convert_pgm.py logo_undefined.pgm > ../converter/logo.h

convert_music: converter_music.py frog.mid
	python3.8 converter_music.py

clean:
	rm -f ../converter/logo.h ../include/melody.asm
