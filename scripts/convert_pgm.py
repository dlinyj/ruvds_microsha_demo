from sys import argv

def pgmread(filename):
  """  This function reads Portable GrayMap (PGM) image files and returns
  a numpy array. Image needs to have P2 or P5 header number.
  Line1 : MagicNum
  Line2 : Width Height
  Line3 : Max Gray level
  Lines starting with # are ignored """
  f = open(filename,'r')
  # Read header information
  count = 0
  while count < 3:
    line = f.readline()
    if line[0] == '#': # Ignore comments
      continue
    count = count + 1
    if count == 1: # Magic num info
      magicNum = line.strip()
      if magicNum != 'P2' and magicNum != 'P5':
        f.close()
        print ('Not a valid PGM file')
        exit()
    elif count == 2: # Width and Height
      [width, height] = (line.strip()).split()
      width = int(width)
      height = int(height)
    elif count == 3: # Max gray level
      maxVal = int(line.strip())
  # Read pixels information
  img = []
  buf = f.read()
  elem = buf.split()
  if len(elem) != width*height:
    print ('Error in number of pixels')
    exit()
  for i in range(height):
    tmpList = []
    for j in range(width):
      tmpList.append(elem[i*width+j])
    img.append(tmpList)
  return (img, width, height)

pgm_path = argv[1]
im, width, height = pgmread(pgm_path)
for strok in im:
	print('"', end ='')
	for color in strok:
		if color == '255':
			print(' ', end ='')
		else:
			print('X', end ='')
	print('",\n', end ='')
