#ifndef __MICROSHA_H__
#define __MICROSHA_H__

void convert_to_canvas_m(char **canvas, char ** m_canvas);
void init_canvas_m(char ** m_canvas);
void canvas_m_diffs(char ** new_canvas_m, char ** old_canvas_m);
void save_to_asmfile(char ** new_canvas_m, char ** old_canvas_m, int iter);
#endif //__MICROSHA_H__
