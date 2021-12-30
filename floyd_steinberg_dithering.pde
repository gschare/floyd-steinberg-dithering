PImage img;

void setup() {
  size(1920, 860);
  img = loadImage("liszt.jpg");
  img.resize(width/3, 0);
  img.filter(GRAY);
  image(img, 0, 0);
}

int index(int x, int y) {
  return x + y * img.width;
}

// img -> image to dither
// pos_x, pos_y -> where to display image on screen
// n -> number of colors
void dither(PImage img, int n, int pos_x, int pos_y) {
  img.loadPixels();

  for (int y=0; y < img.height-1; y++) {
    for (int x=1; x < img.width-1; x++) {
      color pixel = img.pixels[index(x,y)];
      
      float old_r = red(pixel);
      float old_g = green(pixel);
      float old_b = blue(pixel);
      
      int new_r = round((n-1) * old_r / 255) * 255 / (n-1);
      int new_g = round((n-1) * old_g / 255) * 255 / (n-1);
      int new_b = round((n-1) * old_b / 255) * 255 / (n-1);
      
      img.pixels[index(x,y)] = color(new_r, new_g, new_b);
      
      float err_r = old_r - new_r;
      float err_g = old_g - new_g;
      float err_b = old_b - new_b;
      
      int neighbors[] = {index(x+1, y), index(x-1, y+1), index(x, y+1), index(x+1, y+1)};
      float multipliers[] = {7/16.0, 3/16.0, 5/16.0, 1/16.0};
      for (int i=0; i < neighbors.length; i++) {
        int index = neighbors[i];
        color c = img.pixels[index];
        float r = red(c);
        float g = green(c);
        float b = blue(c);
        r += err_r * multipliers[i];
        g += err_g * multipliers[i];
        b += err_b * multipliers[i];
        img.pixels[index] = color(r, g, b);
      }
           
    }
  }
  
  img.updatePixels();
  image(img, pos_x, pos_y);
}

void draw() {
  img = loadImage("liszt.jpg");
  img.resize(width/3, 0);
  img.filter(GRAY);
  dither(img, 2, img.width, 0);
  
  img = loadImage("liszt.jpg");
  img.resize(width/3, 0);
  img.filter(GRAY);
  dither(img, 4, 2*img.width, 0);
  
  save("out.jpg");
  
}
