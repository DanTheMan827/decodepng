#include <stdio.h>
#include <iostream>
#include <iterator>
#include "lodepng/lodepng.h"

int main(int argc, char *argv[])
{
  fprintf(stderr, "decodepng by DanTheMan827\n\n");
  fprintf(stderr, "Build Date: %s \n", BUILD_DATE);
  fprintf(stderr, "    Commit: %s \n", BUILD_COMMIT);
  
  if(argc == 1){
    return 1;
  }
  
  std::vector<unsigned char> image; //the raw pixels
  unsigned width, height;

  //decode
  unsigned error = lodepng::decode(image, width, height, argv[1]);
  
  std::copy(image.begin(), image.end(), std::ostream_iterator<char>(std::cout));
}
