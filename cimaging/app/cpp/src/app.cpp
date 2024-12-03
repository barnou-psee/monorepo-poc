#include "cimaging/app.h"

#include "metavision/foo.h"

namespace CImaging::app {

int algo(int a, int b, int c, int d) {
  using Metavision::foo::add;
  return add(a, b) + add(b, -c) + add(c, d);
}
 
}
