#include "metavision/bar.h"

#include "metavision/foo.h"

namespace Metavision::bar {

int sub(int a, int b) {
  return Metavision::foo::add(a, -b);
}
  
}
