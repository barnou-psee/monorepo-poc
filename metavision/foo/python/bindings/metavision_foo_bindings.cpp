/**********************************************************************************************************************
 * Copyright (c) Prophesee S.A. - All Rights Reserved                                                                 *
 *                                                                                                                    *
 * Subject to Prophesee Metavision Licensing Terms and Conditions ("License T&C's").                                  *
 * You may not use this file except in compliance with these License T&C's.                                           *
 * A copy of these License T&C's is located in the "licensing" folder accompanying this file.                         *
 **********************************************************************************************************************/

#include <pybind11/pybind11.h>
#include <pybind11/numpy.h>

#include "metavision/foo.h"

#define STRINGIFY(x) #x
#define MACRO_STRINGIFY(x) STRINGIFY(x)

namespace py = pybind11;
using namespace Metavision::foo;


PYBIND11_MODULE(_foo, m) {
    m.doc() = R"pbdoc(
        Metavision foo python module
        -------------------------------

        .. currentmodule:: metavision.foo

        .. autosummary::
           :toctree: _generate

           add
    )pbdoc";

    m.def(
        "add", &Metavision::foo::add,
        py::arg("a"), py::arg("b"), 
        R"pbdoc(
            Adds two integers

            Args:
            -----
                a(int): LHS integer
                b(int): RHS integer

            Returns:
            --------
                int: a + b result
        )pbdoc");


#ifdef VERSION_INFO
    m.attr("__version__") = MACRO_STRINGIFY(VERSION_INFO);
#else
    m.attr("__version__") = "dev";
#endif
}
