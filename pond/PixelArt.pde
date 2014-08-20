class PixelArt {
  PImage img;
  int mosaicSize = 5;
  color[] _pixels;
  ArrayList<Pixel> p;
  float x;
  float y;

  PixelArt(float _x, float _y, PImage _img) {
    x = _x;
    y = _y;
    img = _img;
    img.loadPixels();
    p = new ArrayList<Pixel>();
    for (int j = 0; j< img.height; j+=mosaicSize) {
      for (int i = 0; i < img.width; i+=mosaicSize) {
        p.add(new Pixel(i, j, 5, 10, img.pixels[j*img.width + i]));
        for (Pixel dot : p) {
          dot.explode();
        }
      }
    }
  }
  void update() {
    for (int i = 0; i < p.size (); i++) {
      Pixel dot = p.get(i);
      dot.update();
      dot.init();
    }
  }
  void move(float tx, float ty) {
    float dist = sqrt((tx-x)*(tx-x)+(ty-y)*(ty-y));
    float direction = atan2(x-tx, ty-y)+HALF_PI;
    x += dist*cos(direction) / 10;
    y += dist*sin(direction) / 10;
  }
}

