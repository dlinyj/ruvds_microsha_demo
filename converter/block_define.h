#ifndef __BLOCK_DEFINE_H___
#define __BLOCK_DEFINE_H___
// X-
// --
#ifdef MICROSHA
#define TOP_LEFT_POINT		0x01
#else 
#define TOP_LEFT_POINT L'▘'
#endif

// -X
// --
#ifdef MICROSHA
#define TOP_RIGHT_POINT		0x02
#else 
#define TOP_RIGHT_POINT L'▝'
#endif

// XX
// --
#ifdef MICROSHA
#define UP_HALF_OF_BLOK		0x03
#else 
#define UP_HALF_OF_BLOK L'▀'
#endif

// --
// -X
#ifdef MICROSHA
#define BOT_RIGHT_POINT		0x04
#else 
#define BOT_RIGHT_POINT L'▗'
#endif

// X-
// -X
#ifdef MICROSHA
#define DIAGONAL_FLTR		0x05
#else 
#define DIAGONAL_FLTR L'▚'
#endif

// -X
// -X
#ifdef MICROSHA
#define VERT_RIGHT			0x06
#else 
#define VERT_RIGHT L'▐'
#endif

// XX
// -X
#ifdef MICROSHA
#define BOT_LEFT_POINT_B	0x07
#else 
#define BOT_LEFT_POINT_B L'▜'
#endif

// --
// X- 
#ifdef MICROSHA
#define BOT_LEFT_POINT		0x10
#else 
#define BOT_LEFT_POINT L'▖'
#endif

// X-
// X-
#ifdef MICROSHA
#define VERT_LEFT 			0x11
#else 
#define VERT_LEFT L'▌'
#endif

// -X
// X-
#ifdef MICROSHA
#define DIAGONAL_FRTL		0x12
#else 
#define DIAGONAL_FRTL L'▞'
#endif

// XX
// X-
#ifdef MICROSHA
#define BOT_RIGHT_POINT_B	0x13
#else 
#define BOT_RIGHT_POINT_B L'▛'
#endif

// --
// XX
#ifdef MICROSHA
#define DOWN_HALF_OF_BLOK	0x14
#else 
#define DOWN_HALF_OF_BLOK L'▄'
#endif

// X-
// XX
#ifdef MICROSHA
#define TOP_RIGHT_POINT_B	0x15
#else 
#define TOP_RIGHT_POINT_B L'▙'
#endif

// -X
// XX
#ifdef MICROSHA
#define TOP_LEFT_POINT_B	0x16
#else 
#define TOP_LEFT_POINT_B L'▟'
#endif

// XX
// XX
#ifdef MICROSHA
#define FULL_BLOCK			0x17
#else 
#define FULL_BLOCK L'█'
#endif

#endif // #ifndef __BLOCK_DEFINE_H___
