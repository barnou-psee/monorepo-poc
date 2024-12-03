#include <gtest/gtest.h>

#include "metavision/bar.h"

namespace {

TEST(MetavisionFoo, add) {
  EXPECT_EQ(1, Metavision::bar::sub(1, 0));
  EXPECT_EQ(-1, Metavision::bar::sub(2, 3));
}

}
