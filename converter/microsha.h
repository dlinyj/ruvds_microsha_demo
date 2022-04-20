#ifndef __MICROSHA_H__
#define __MICROSHA_H__

#define M_SCREEN_WIDTH 78
#define M_SCREEN_HEIGHT 30

void convert_to_canvas_m(char **canvas, char ** m_canvas);
void init_canvas_m(char **init_image, char ** m_canvas);
void canvas_m_diffs(char ** new_canvas_m, char ** old_canvas_m);

#endif //__MICROSHA_H__
