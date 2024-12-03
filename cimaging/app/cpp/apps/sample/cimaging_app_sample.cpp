#include <iostream>

#include "cimaging/app.h"

using namespace std;

int main(void) {
  int a, b, c, d;
  cin >> a >> b >> c >> d;

  auto result = CImaging::app::algo(a, b, c, d);

  std::cout << "CImaging::app::algo(" << a << ", " << b << ", " << c << ", " << d << ") = " << result << std::endl;
  return 0;
}
