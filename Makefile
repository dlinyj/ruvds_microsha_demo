all: microsha_demo.rom.RKM

microsha_demo.rom.RKM: include/melody.asm include/frames.asm converter_rkm/convert_rkm
	zasm --asm8080 -l0 microsha_demo.asm
	converter_rkm/convert_rkm microsha_demo.rom

include/frames.asm: converter/logo.h
	make -C converter
	converter/convert 2> include/frames.asm

converter/logo.h:
	make -C scripts convert_pgm

include/melody.asm:
	make -C scripts convert_music

converter_rkm/convert_rkm:
	make -C converter_rkm

clean:
	make -C scripts clean
	make -C converter clean
	make -C converter_rkm clean
	rm -f microsha_demo.rom.RKM microsha_demo.rom include/frames.asm


