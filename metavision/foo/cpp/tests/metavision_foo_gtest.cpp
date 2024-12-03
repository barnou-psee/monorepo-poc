#include <gtest/gtest.h>

#include "metavision/foo.h"

namespace {

TEST(MetavisionFoo, add) {
  EXPECT_EQ(1, Metavision::foo::add(1, 0));
  EXPECT_EQ(5, Metavision::foo::add(2, 3));
}

}
