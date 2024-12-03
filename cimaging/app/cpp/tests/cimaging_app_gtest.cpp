#include <gtest/gtest.h>

#include "cimaging/app.h"

namespace {

TEST(CImagingApp, algo) {
  EXPECT_EQ(0, CImaging::app::algo(0, 0, 0, 0));
}

}
