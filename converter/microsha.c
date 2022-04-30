#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "block_define.h"

#define F_SCREEN_WIDTH 156
#define F_SCREEN_HEIGHT 60

#define M_SCREEN_WIDTH 78
#define M_SCREEN_HEIGHT 30

//#define MAX_CHANGE 255 //максимально допустимое количество изменений во фреймах
#define MAX_CHANGE 1000 //максимально допустимое количество изменений во фреймах

void convert_to_canvas_m(char **image, char ** m_canvas) {
	int i, j;
	for (i = 0; i < F_SCREEN_HEIGHT; i+=2) {
		for (j =0; j < F_SCREEN_WIDTH; j+=2) {
			if ((image[i][j]   == 'X') && (image[i][j+1]   == ' ') && \
				(image[i+1][j] == ' ') && (image[i+1][j+1] == ' ')){
				m_canvas[i/2][j/2] = M_TOP_LEFT_POINT;
			}
			if ((image[i][j]   == ' ') && (image[i][j+1]   == 'X') && \
				(image[i+1][j] == ' ') && (image[i+1][j+1] == ' ')){
				m_canvas[i/2][j/2] = M_TOP_RIGHT_POINT;
			}
			if ((image[i][j]   == 'X') && (image[i][j+1]   == 'X') && \
				(image[i+1][j] == ' ') && (image[i+1][j+1] == ' ')){
				m_canvas[i/2][j/2] = M_UP_HALF_OF_BLOK;
			}
			if ((image[i][j]   == ' ') && (image[i][j+1]   == ' ') && \
				(image[i+1][j] == ' ') && (image[i+1][j+1] == 'X')){
				m_canvas[i/2][j/2] = M_BOT_RIGHT_POINT;
			}
			if ((image[i][j]   == 'X') && (image[i][j+1]   == ' ') && \
				(image[i+1][j] == ' ') && (image[i+1][j+1] == 'X')){
				m_canvas[i/2][j/2] = M_DIAGONAL_FLTR;
			}
			if ((image[i][j]   == ' ') && (image[i][j+1]   == 'X') && \
				(image[i+1][j] == ' ') && (image[i+1][j+1] == 'X')){
				m_canvas[i/2][j/2] = M_VERT_RIGHT;
			}
			if ((image[i][j]   == 'X') && (image[i][j+1]   == 'X') && \
				(image[i+1][j] == ' ') && (image[i+1][j+1] == 'X')){
				m_canvas[i/2][j/2] = M_BOT_LEFT_POINT_B;
			}
			if ((image[i][j]   == ' ') && (image[i][j+1]   == ' ') && \
				(image[i+1][j] == 'X') && (image[i+1][j+1] == ' ')){
				m_canvas[i/2][j/2] = M_BOT_LEFT_POINT;
			}
			if ((image[i][j]   == 'X') && (image[i][j+1]   == ' ') && \
				(image[i+1][j] == 'X') && (image[i+1][j+1] == ' ')){
				m_canvas[i/2][j/2] = M_VERT_LEFT;
			}
			if ((image[i][j]   == ' ') && (image[i][j+1]   == 'X') && \
				(image[i+1][j] == 'X') && (image[i+1][j+1] == ' ')){
				m_canvas[i/2][j/2] = M_DIAGONAL_FRTL;
			}
			if ((image[i][j]   == 'X') && (image[i][j+1]   == 'X') && \
				(image[i+1][j] == 'X') && (image[i+1][j+1] == ' ')){
				m_canvas[i/2][j/2] = M_BOT_RIGHT_POINT_B;
			}

			if ((image[i][j]   == ' ') && (image[i][j+1]   == ' ') && \
				(image[i+1][j] == 'X') && (image[i+1][j+1] == 'X')){
				m_canvas[i/2][j/2] = M_DOWN_HALF_OF_BLOK;
			}
			if ((image[i][j]   == 'X') && (image[i][j+1]   == ' ') && \
				(image[i+1][j] == 'X') && (image[i+1][j+1] == 'X')){
				m_canvas[i/2][j/2] = M_TOP_RIGHT_POINT_B;
			}
			if ((image[i][j]   == ' ') && (image[i][j+1]   == 'X') && \
				(image[i+1][j] == 'X') && (image[i+1][j+1] == 'X')){
				m_canvas[i/2][j/2] = M_TOP_LEFT_POINT_B;
			}
			if ((image[i][j]   == 'X') && (image[i][j+1]   == 'X') && \
				(image[i+1][j] == 'X') && (image[i+1][j+1] == 'X')){
				m_canvas[i/2][j/2] = M_FULL_BLOCK;
			}
			if ((image[i][j]   == ' ') && (image[i][j+1]   == ' ') && \
				(image[i+1][j] == ' ') && (image[i+1][j+1] == ' ')){
				m_canvas[i/2][j/2] = ' ';
			}
		}
	}
}

void init_canvas_m(char ** m_canvas) {
	for (int i = 0; i < M_SCREEN_HEIGHT; ++i) {
		m_canvas[i] = malloc(M_SCREEN_WIDTH);
		memset(m_canvas[i], ' ',M_SCREEN_WIDTH);
	}
}

void save_to_asmfile(char ** new_canvas_m, char ** old_canvas_m, int iter) {
	int x, y;
	if (iter == 0) {
		fprintf(stderr, "initial_frame:\n");
		for (y = 0; y < M_SCREEN_HEIGHT; ++y) {
			fprintf(stderr, "  db ");
			for (x = 0; x < M_SCREEN_WIDTH-1; ++x)
				fprintf(stderr, "0%02Xh, ", new_canvas_m[y][x]);
			fprintf(stderr, "0%02Xh\n", new_canvas_m[y][M_SCREEN_WIDTH-1]);
		}
		fprintf(stderr, "\n");
	} else {
		int offsets[MAX_CHANGE];
		char change_symbol[MAX_CHANGE];
		int offset_n = 0;
		for (y = 0; y < M_SCREEN_HEIGHT; y++) {
			for (x = 0; x < M_SCREEN_WIDTH; x++) {
				if (new_canvas_m[y][x] != old_canvas_m[y][x]) {
					int offset = y * M_SCREEN_WIDTH + x;
					assert(offset_n < sizeof(offsets) / sizeof(*offsets)); //Даёт ошибку
					change_symbol[offset_n] = new_canvas_m[y][x];
					offsets[offset_n++] = offset;
				}
			}
		}
		if (offset_n >= MAX_CHANGE) {
			printf("iter = %d diffs = %d\n", iter, offset_n);
			assert(0);
		}
		fprintf(stderr, "frame_%03d: dw 0%02xh\n", iter, offset_n);
		for (int i = 0; i < offset_n; i++) {
			fprintf(stderr, "  dw %xh\n", offsets[i] + 0x76d0);
			fprintf(stderr, "  db 0%02xh\n", change_symbol[i]);
		}
		fprintf(stderr, "\n");
	}
}
