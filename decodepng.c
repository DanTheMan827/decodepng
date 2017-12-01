#include <stdio.h>
#include <stdint.h>
#include "lodepng/lodepng.h"

static inline void rgbSwap(unsigned char*buf)
{
  unsigned char t;
  t=buf[0];
  buf[0]=buf[2];
  buf[2]=t;
  buf[3]=0;
}

static void rgbSwapImage(unsigned char*buf,unsigned len)
{
  for(unsigned i=0;i<len;i+=4)
  {
    rgbSwap(buf+i);
  }
}

int main(int argc, char *argv[])
{
  if(argc < 2)
  {
    fprintf(stderr, "decodepng by DanTheMan827 and madmonkey1907\n\n");
    fprintf(stderr, "Build Date: %s \n", BUILD_DATE);
    fprintf(stderr, "    Commit: %s \n", BUILD_COMMIT);
    return 1;
  }

  unsigned char*image=0; //the raw pixels
  unsigned width=0,height=0;

  //decode
  unsigned error = lodepng_decode32_file(&image, &width, &height, argv[1]);
  
  if(error)
    return error;

  unsigned imageLength = width * height * 4;
  if((image==0)||(imageLength==0))
  {
    fprintf(stderr, "SOMEBODY SET UP US THE BOMB\n");
    return 1;
  }
  
  rgbSwapImage(image,imageLength);
  fwrite(image, 1, imageLength, stdout);
  fwrite(image, 1, imageLength, stdout);
  fflush(stdout);

  return 0;
}