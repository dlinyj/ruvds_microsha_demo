#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "block_define.h"
#include <wchar.h>
#include <locale.h>
#include <string.h>
#include <unistd.h>
#include <math.h>

#include "microsha.h"

#define ESC "\033"
#define home() 			printf(ESC "[H") //Move cursor to the indicated row, column (origin at 1,1)
#define clrscr()		printf(ESC "[2J") //lear the screen, move to (1,1)
#define gotoxy(x,y)		printf(ESC "[%d;%dH", y, x);

#define visible_cursor() printf(ESC "[?251");

#define SCREEN_WIDTH 156
#define SCREEN_HEIGHT 60

#define M_SCREEN_WIDTH 78
#define M_SCREEN_HEIGHT 30

#define SHOW

char * image[60] = {
"                                                                                                                                                            ",
"                                     XXXXXX                                                                                                                 ",
"                                  XXXXXXXXXXXX                                                                                                              ",
"                                XXXXXXXXXXXXXXXX                                                                                                            ",
"                               XXXXXXXXXXXXXXXXXX                                                                                                           ",
"                             XXXXXXXXXXXXXXXXXXXXXX                                                                                                         ",
"                            XXXXXXXXXXXXXXXXXXXXXXXX                                                                                                        ",
"                           XXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                                       ",
"                          XXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                                       ",
"                         XXXXXXXXXXX        XXXXXXXXXX                                                                                                      ",
"                         XXXXXXXXX            XXXXXXXXX                                                                                                     ",
"                        XXXXXXXX               XXXXXXXX                                                                                                     ",
"                       XXXXXXXX                  XXXXXXX                                                                                                    ",
"                       XXXXXXX                   XXXXXXXXXXXXXXXX                                                                                           ",
"                       XXXXXXX                    XXXXXXXXXXXXXXXXX                                                                                         ",
"                       XXXXXX                      XXXXXXXXXXXXXXXXXX                                                                                       ",
"                      XXXXXXX                      XXXXXXXXXXXXXXXXXXX                                                                                      ",
"                      XXXXXX                        XXXXXXXXXXXXXXXXXXX                                                                                     ",
"                      XXXXXX                        XXXXXXXXXXXXXXXXXXXX                                                                                    ",
"                      XXXXXX                        XXXXXXXXXXXXXXXXXXXXX                                                                                   ",
"                      XXXXXX                        XXXX         XXXXXXXX                                                                                   ",
"                 XXXXXXXXXXX                                      XXXXXXXX                                                                                  ",
"                XXXXXXXXXXXX                                       XXXXXXX                                                                                  ",
"              XXXXXXXXXXXXXX                                        XXXXXXX                                                                                 ",
"             XXXXXXXXXXXXXXX                                         XXXXXX                                                                                 ",
"            XXXXXXXXXXXXXXXX                                         XXXXXXX                                                                                ",
"           XXXXXXXXXXXXXXXXX                                         XXXXXXX                                                                                ",
"          XXXXXXXXXXX                                                 XXXXXX                                                                                ",
"         XXXXXXXXX                                                                                                                                          ",
"         XXXXXXXX                                                                                                                                           ",
"        XXXXXXXX                                                                                                                                            ",
"       XXXXXXXX                     XXXXXXXXXXXX        XXXXX          XXXXX       XXXX                XXXX   XXXXXXXXXXX                   XXXXXX          ",
"       XXXXXXX                     XXXXXXXXXXXXXXX     XXXXXXX        XXXXXXX      XXXX                XXXX   XXXXXXXXXXXXXX             XXXXXXXXXXX        ",
"       XXXXXXX                     XXXXXXXXXXXXXXXXX   XXXXXXX        XXXXXXX      XXXX                XXXX   XXXXXXXXXXXXXXXX          XXXXXXXXXXXXXX      ",
"       XXXXXXX                     XXXXXXXXXXXXXXXXXX  XXXXXXX        XXXXXXX       XXXX              XXXX    XXXXXXXXXXXXXXXXX        XXXXX       XXXX     ",
"       XXXXXX                      XXXXXXXXXXXXXXXXXXX XXXXXXX        XXXXXXX       XXXX              XXXX    XXXX        XXXXXX      XXXXX         XXXX    ",
"       XXXXXX                      XXXXXXXXXXXXXXXXXXX XXXXXXX        XXXXXXX       XXXX              XXXX    XXXX          XXXXX     XXXX                  ",
"       XXXXXX                      XXXXXX      XXXXXXX XXXXXXX        XXXXXXX        XXXX            XXXX     XXXX           XXXXX    XXXX                  ",
"       XXXXXX                      XXXXXX       XXXXXX XXXXXXX        XXXXXXX        XXXX            XXXX     XXXX            XXXX    XXXXX                 ",
"       XXXXXX                      XXXXXX       XXXXXX XXXXXXX        XXXXXXX         XXXX          XXXX      XXXX            XXXXX    XXXXX                ",
"       XXXXXX                      XXXXXX       XXXXXX XXXXXXX        XXXXXXX         XXXX          XXXX      XXXX            XXXXX     XXXXX               ",
"       XXXXXX                      XXXXXX       XXXXXX XXXXXXX        XXXXXXX          XXXX        XXXX       XXXX             XXXX      XXXXX              ",
"       XXXXXX                      XXXXXX       XXXXXX XXXXXXX        XXXXXXX          XXXX        XXXX       XXXX             XXXXX      XXXXX             ",
"       XXXXXX                      XXXXXX      XXXXXXX XXXXXXX        XXXXXXX           XXXX       XXXX       XXXX             XXXXX       XXXXX            ",
"       XXXXXXX                     XXXXXXXXXXXXXXXXXXX XXXXXXX        XXXXXXX           XXXX      XXXX        XXXX             XXXXX        XXXXX           ",
"       XXXXXXX                     XXXXXXXXXXXXXXXXXXX XXXXXXX        XXXXXXX            XXXX     XXXX        XXXX             XXXXX         XXXXX          ",
"       XXXXXXXX                    XXXXXXXXXXXXXXXXXX  XXXXXXX        XXXXXXX            XXXXX   XXXXX        XXXX             XXXXX          XXXXX         ",
"        XXXXXXX                    XXXXXXXXXXXXXXXX    XXXXXXX        XXXXXXX             XXXX   XXXX         XXXX             XXXXX           XXXXX        ",
"        XXXXXXXX                   XXXXXX XXXXXXXX     XXXXXXX        XXXXXXX             XXXX   XXXX         XXXX             XXXX             XXXXX       ",
"         XXXXXXXX                  XXXXXX XXXXXXXX     XXXXXXX        XXXXXXX             XXXXX XXXXX         XXXX            XXXXX              XXXXX      ",
"         XXXXXXXXXX                XXXXXX  XXXXXXXX    XXXXXXX        XXXXXX               XXXX XXXX          XXXX            XXXXX               XXXXX     ",
"          XXXXXXXXXX               XXXXXX   XXXXXXXX   XXXXXXX        XXXXXX               XXXXXXXXX          XXXX            XXXX                 XXXXX    ",
"           XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    XXXXXXXX   XXXXXXX      XXXXXXX               XXXXXXXX           XXXX           XXXX                  XXXXX    ",
"            XXXXXXXXXXXXXXXXXXXXXXXXXXXXX     XXXXXXXX  XXXXXXXXXXXXXXXXXXX                 XXXXXXX           XXXX         XXXXXX    XXXX          XXXXX    ",
"              XXXXXXXXXXXXXXXXXXXXXXXXXXX      XXXXXXX   XXXXXXXXXXXXXXXXXX                 XXXXXXX           XXXXXXXXXXXXXXXXXX     XXXX        XXXXXX     ",
"               XXXXXXXXXXXXXXXXXXXXXXXXXX      XXXXXXXX   XXXXXXXXXXXXXXXX                   XXXXX            XXXXXXXXXXXXXXXXX       XXXXXXXXXXXXXXXX      ",
"                 XXXXXXXXXXXXXXXXXXXXXXXX       XXXXXXXX   XXXXXXXXXXXXXX                    XXXXX            XXXXXXXXXXXXXXX          XXXXXXXXXXXXX        ",
"                   XXXXXXXXXXXXXXXXXXXXXX        XXXXXXX     XXXXXXXXXX                       XXX             XXXXXXXXXXXXX             XXXXXXXXXX          ",
"                                                                                                                                                            ",
"                                                                                                                                                            ",

};

void print_image(char ** image) {
	int i, j;
	home();
	clrscr();
	for (i = 0; i < SCREEN_HEIGHT; i+=2) {
		for (j =0; j < SCREEN_WIDTH; j+=2) {
			if ((image[i][j]   == 'X') && (image[i][j+1]   == ' ') && \
				(image[i+1][j] == ' ') && (image[i+1][j+1] == ' ')){
				printf("%lc", TOP_LEFT_POINT);
			}
			
			if ((image[i][j]   == ' ') && (image[i][j+1]   == 'X') && \
				(image[i+1][j] == ' ') && (image[i+1][j+1] == ' ')){
				printf("%lc", TOP_RIGHT_POINT);
			}
			if ((image[i][j]   == 'X') && (image[i][j+1]   == 'X') && \
				(image[i+1][j] == ' ') && (image[i+1][j+1] == ' ')){
				printf("%lc", UP_HALF_OF_BLOK);
			}
			if ((image[i][j]   == ' ') && (image[i][j+1]   == ' ') && \
				(image[i+1][j] == ' ') && (image[i+1][j+1] == 'X')){
				printf("%lc", BOT_RIGHT_POINT);
			}
			if ((image[i][j]   == 'X') && (image[i][j+1]   == ' ') && \
				(image[i+1][j] == ' ') && (image[i+1][j+1] == 'X')){
				printf("%lc", DIAGONAL_FLTR);
			}
			if ((image[i][j]   == ' ') && (image[i][j+1]   == 'X') && \
				(image[i+1][j] == ' ') && (image[i+1][j+1] == 'X')){
				printf("%lc", VERT_RIGHT);
			}
			if ((image[i][j]   == 'X') && (image[i][j+1]   == 'X') && \
				(image[i+1][j] == ' ') && (image[i+1][j+1] == 'X')){
				printf("%lc", BOT_LEFT_POINT_B);
			}
			if ((image[i][j]   == ' ') && (image[i][j+1]   == ' ') && \
				(image[i+1][j] == 'X') && (image[i+1][j+1] == ' ')){
				printf("%lc", BOT_LEFT_POINT);
			}
			if ((image[i][j]   == 'X') && (image[i][j+1]   == ' ') && \
				(image[i+1][j] == 'X') && (image[i+1][j+1] == ' ')){
				printf("%lc", VERT_LEFT);
			}
			if ((image[i][j]   == ' ') && (image[i][j+1]   == 'X') && \
				(image[i+1][j] == 'X') && (image[i+1][j+1] == ' ')){
				printf("%lc", DIAGONAL_FRTL);
			}
			if ((image[i][j]   == 'X') && (image[i][j+1]   == 'X') && \
				(image[i+1][j] == 'X') && (image[i+1][j+1] == ' ')){
				printf("%lc", BOT_RIGHT_POINT_B);
			}

			if ((image[i][j]   == ' ') && (image[i][j+1]   == ' ') && \
				(image[i+1][j] == 'X') && (image[i+1][j+1] == 'X')){
				printf("%lc", DOWN_HALF_OF_BLOK);
			}
			if ((image[i][j]   == 'X') && (image[i][j+1]   == ' ') && \
				(image[i+1][j] == 'X') && (image[i+1][j+1] == 'X')){
				printf("%lc", TOP_RIGHT_POINT_B);
			}
			if ((image[i][j]   == ' ') && (image[i][j+1]   == 'X') && \
				(image[i+1][j] == 'X') && (image[i+1][j+1] == 'X')){
				printf("%lc", TOP_LEFT_POINT_B);
			}
			if ((image[i][j]   == 'X') && (image[i][j+1]   == 'X') && \
				(image[i+1][j] == 'X') && (image[i+1][j+1] == 'X')){
				printf("%lc", FULL_BLOCK);
			}
			if ((image[i][j]   == ' ') && (image[i][j+1]   == ' ') && \
				(image[i+1][j] == ' ') && (image[i+1][j+1] == ' ')){
				putchar(' ');
			}
		}
		putchar('\n');
	}
}

void line (char ** canvas, double degree_axix_of_rotation) {
	double k = tan((180.0 - degree_axix_of_rotation) * M_PI / 180.0);
	#define Y1 (SCREEN_HEIGHT/2)
	#define X1 (SCREEN_WIDTH/2)
	//printf("k = %f\n",k);

	
	if ((degree_axix_of_rotation > 45.0)  && (degree_axix_of_rotation < 135.0)) {
		for (int y = 0; y < SCREEN_HEIGHT; y++) {
			int x = (int)((y - Y1)/k + X1 + 0.5);
//			printf("x = %d, y = %d\n", x,y);
			if ((x >= 0) && (x <= SCREEN_WIDTH)) {
				canvas[y][x] = 'X';
			}
		}
	}
	 
	if ((degree_axix_of_rotation <= 45.0) || (degree_axix_of_rotation >= 135.0)){
		for (int x = 0; x < SCREEN_WIDTH; x++) {
			int y = (int)(k * (x - X1) + Y1 + 0.5);
			if ((y >= 0) && (y <= SCREEN_HEIGHT)) {
				canvas[y][x] = 'X';
			}
//			printf("x = %d, y = %d\n", x,y);
		}
	} 
}

void vertical_line (char ** canvas) {
	for (int i = 0; i < SCREEN_HEIGHT; ++i) {
		canvas[i][SCREEN_WIDTH/2] = 'X';
	}
}

void horisontal_line (char ** canvas) {
	for (int i = 0; i < SCREEN_WIDTH; ++i) {
		canvas[SCREEN_HEIGHT/2][i] = 'X';
	}
}

void clear_canvas(char ** canvas) {
	for (int i = 0; i < SCREEN_HEIGHT; ++i) {
		memset(canvas[i], ' ',SCREEN_WIDTH);
		canvas[i][SCREEN_WIDTH + 1] = '\0';
	}
}

void init_canvas(char ** canvas) {
	for (int i = 0; i < SCREEN_HEIGHT; ++i) {
		canvas[i] = malloc(SCREEN_WIDTH + 1);
		memset(canvas[i], ' ',SCREEN_WIDTH);
		canvas[i][SCREEN_WIDTH + 1] = '\0';
	}
}

void rotate(char ** image, char ** canvas, double r_degree) {
	for (int y = 0; y < SCREEN_HEIGHT; y++) {
		for (int x = 0; x < SCREEN_WIDTH; x++) {
			int xnew = (int)((X1 - x) * cos ((180 -r_degree) * M_PI / 180.0) + X1 + 0.5);
			if (canvas[y][xnew] != 'X') {
				canvas[y][xnew] = image[y][x];
			}
		}
	}
}

void full_rotate(char ** image, char ** canvas, double r_degree, double gamma_degree) {
	for (int y = 0; y < SCREEN_HEIGHT; y++) {
		for (int x = 0; x < SCREEN_WIDTH; x++) {
			int xnew = (int)((((X1 - x) * cos ((180 - r_degree) * M_PI / 180.0) + X1) * cos(180 - gamma_degree) * M_PI / 180.0) + 0.5);
			int ynew = (int)((((Y1 - y) * cos ((180 - r_degree) * M_PI / 180.0) + Y1) *  sin(180 - gamma_degree) * M_PI / 180.0) + 0.5);
			if ((xnew >= 0 ) && (xnew <= SCREEN_WIDTH) && (ynew >= 0) && (ynew <= SCREEN_WIDTH)) {
				if (canvas[ynew][xnew] != 'X') {
					canvas[ynew][xnew] = image[y][x];
				}
			}
		}
	}
}

int main (void) {
	setlocale(LC_ALL, "en_US.utf8");

	char* canvas[SCREEN_HEIGHT];
	char * m_canvas1[M_SCREEN_HEIGHT];
	char * m_canvas2[M_SCREEN_HEIGHT];

	char ** new_canvas_m;
	char ** old_canvas_m;
	char ** tmp_m;

	int frames = 1;
	init_canvas(canvas);
	
	init_canvas_m(m_canvas1);
	init_canvas_m(m_canvas2);
	

	convert_to_canvas_m(image, m_canvas1);
	save_to_asmfile(m_canvas1, NULL, 0); //save first frame

	old_canvas_m = m_canvas1;
	new_canvas_m = m_canvas2;

	//for (int i = 20; i <= 340; i+=20) { //годное время
	for (int i = 30; i <= 330; i+=30) {
//		line(f1, (double)i);

		rotate(image, canvas, (double)i);
#ifdef  SHOW
		print_image(canvas);
		printf("degree = %d\n", i);
		usleep(200000);
#endif
		convert_to_canvas_m(canvas, new_canvas_m);
		save_to_asmfile(new_canvas_m, old_canvas_m, frames++);
		tmp_m = old_canvas_m;
		old_canvas_m = new_canvas_m;
		new_canvas_m = tmp_m;
		clear_canvas(canvas);
	}

	fprintf(stderr, "frame_%03d: dw 0%02xh\n", frames, 0xFFFF);
	printf("All frames = %d\n", frames);
	for (int i = 0; i < SCREEN_HEIGHT; ++i) {
		free(canvas[i]);
	}
	for (int i = 0; i < M_SCREEN_HEIGHT; ++i) {
		free(m_canvas1[i]);
		free(m_canvas2[i]);
	}
	return 0;
}
