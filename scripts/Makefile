# Makefile

.PHONY: clean  all convert_music convert_pgm

all: convert_pgm convert_music

convert_pgm: convert_pgm.py logo_ruvds.pgm
	python3.7 convert_pgm.py logo_ruvds.pgm > ../converter/logo.h

convert_music: converter_music.py ppk.mid
	python3.7 converter_music.py

clean:
	rm -f ../converter/logo.h ../include/melody.asm
