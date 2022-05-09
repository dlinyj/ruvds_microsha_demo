#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h> 
#include <inttypes.h> 

#define OUT_EX ".RKM"

void write_byte_to_file (FILE * file_out, uint8_t byte_o) {
	fwrite(&byte_o, sizeof (uint8_t), 1, file_out);
}

int main ( int32_t argc, uint8_t *argv[] ) {
	if ( argc != 2 ) {
		printf( "usage: %s filename", argv[0] );
	} else {
		FILE *file = fopen( argv[1], "r" );
		if ( file == 0 ) {
			printf( "Could not open filen" );
		} else {
			uint32_t x;
			uint32_t i = 0;
			uint8_t csm_lo = 0;
			uint8_t csm_hi = 0;
			
			//генерируем выходной файл
			uint8_t * res_filename = calloc(strlen(argv[1]) + strlen(OUT_EX) + 1, 1);
			strcat(res_filename, argv[1]);
			strcat(res_filename, OUT_EX);
			printf("filename output = %s\n", res_filename);
			FILE *file_out = fopen(res_filename, "w" );
			
			
			//Получаем размер файла
			fseek(file, 0, SEEK_END);
			uint32_t filesize = ftello(file) - 1;
			fseek(file, 0, SEEK_SET);
			printf("File = %02x %02x\n", (uint32_t)filesize >> 8 & 0x00FF, (uint32_t)0x00FF & filesize);
			
			write_byte_to_file(file_out, 0);
			write_byte_to_file(file_out, 0);
			write_byte_to_file(file_out, (uint8_t)(filesize >> 8 & 0x00FF));
			write_byte_to_file(file_out, (uint8_t)(0x00FF & filesize));
			
			while  ( ( x = fgetc( file ) ) != EOF ) {
				write_byte_to_file(file_out, (uint8_t)(0x00FF & x));
				if (i++ % 2 == 0) {
					csm_lo ^= (uint32_t)0x00FF & x;
				} else {
					csm_hi ^= (uint32_t)0x00FF & x;
				}
			}
			printf("%02x  %02x\n", (uint32_t)0x00FF & csm_hi, (uint32_t)0x00FF & csm_lo);
			write_byte_to_file(file_out, csm_hi);
			write_byte_to_file(file_out, csm_lo);
			fclose(file);
			fclose(file_out);
			free(res_filename);
		}
	}
	return 0;
}
