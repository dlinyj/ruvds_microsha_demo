#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "block_define.h"
#include <wchar.h>
#include <locale.h>
#include <string.h>
#include <unistd.h>
#include <math.h>


#define ESC "\033"
#define home() 			printf(ESC "[H") //Move cursor to the indicated row, column (origin at 1,1)
#define clrscr()		printf(ESC "[2J") //lear the screen, move to (1,1)
#define gotoxy(x,y)		printf(ESC "[%d;%dH", y, x);

#define visible_cursor() printf(ESC "[?251");

#define SCREEN_WIDTH 156
#define SCREEN_HEIGHT 60

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
"         XXXXXXXX                  XXXXXX XXXXXXXX     XXXXXXX        XXXXXXX             XXXXX XXXXX         XXXX            XXXXX              XXXXX     ",
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

void clear_canvas(char ** canvas) {
	for (int i = 0; i < SCREEN_HEIGHT; ++i) {
		memset(canvas[i], ' ',SCREEN_WIDTH);
		canvas[i][SCREEN_WIDTH + 1] = '\0';
	}
}

int main (void) {
	setlocale(LC_ALL, "en_US.utf8");
	//print_image(image);
	char* f1[SCREEN_HEIGHT];
	//char* f2[SCREEN_HEIGHT];
	int i;

	for (i = 0; i < SCREEN_HEIGHT; ++i) {
		f1[i] = malloc(SCREEN_WIDTH + 1);
		memset(f1[i], ' ',SCREEN_WIDTH);
		f1[i][SCREEN_WIDTH + 1] = '\0';
		//f2[i] = malloc(SCREEN_WIDTH + 1);
	}

	//Горизонтальная линия
	for (i = 0; i < SCREEN_WIDTH; ++i) {
		f1[SCREEN_HEIGHT/2][i] = 'X';
	}
	//Вертикальная линия
	for (i = 0; i < SCREEN_HEIGHT; ++i) {
		f1[i][SCREEN_WIDTH/2] = 'X';
	}
	for (i = 0; i <= 180; i++) {
		home();
		clrscr();
		line(f1, (double)i);
		print_image(f1);
		printf("degree = %d\n", i);
		//clear_canvas(f1);
		usleep(50000);
	}

	for (i = 0; i < SCREEN_HEIGHT; ++i) {
		free(f1[i]);
//		free(f2[i]);
	}
	return 0;
}
