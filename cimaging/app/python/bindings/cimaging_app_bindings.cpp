/**********************************************************************************************************************
 * Copyright (c) Prophesee S.A. - All Rights Reserved                                                                 *
 *                                                                                                                    *
 * Subject to Prophesee CImaging Licensing Terms and Conditions ("License T&C's").                                  *
 * You may not use this file except in compliance with these License T&C's.                                           *
 * A copy of these License T&C's is located in the "licensing" folder accompanying this file.                         *
 **********************************************************************************************************************/

#include <pybind11/pybind11.h>
#include <pybind11/numpy.h>

#include "cimaging/app.h"

#define STRINGIFY(x) #x
#define MACRO_STRINGIFY(x) STRINGIFY(x)

namespace py = pybind11;
using namespace CImaging::app;


PYBIND11_MODULE(_app, m) {
    m.doc() = R"pbdoc(
        CImaging app python module
        -------------------------------

        .. currentmodule:: cimaging.app

        .. autosummary::
           :toctree: _generate

           algo
    )pbdoc";

    m.def(
        "algo", &CImaging::app::algo,
        py::arg("a"), py::arg("b"), py::arg("c"), py::arg("d"),
        R"pbdoc(
            Runs the algorithm

            Args:
            -----
                a(int): a parameter
                b(int): b parameter
                c(int): c parameter
                d(int): d parameter

            Returns:
            --------
                int: algo result
        )pbdoc");


#ifdef VERSION_INFO
    m.attr("__version__") = MACRO_STRINGIFY(VERSION_INFO);
#else
    m.attr("__version__") = "dev";
#endif
}
