# Copyright (c) Prophesee S.A. - All Rights Reserved
#
# Subject to Prophesee Metavision Licensing Terms and Conditions ("License T&C's").
# You may not use this file except in compliance with these License T&C's.
# A copy of these License T&C's is located in the "licensing" folder accompanying this file.

import metavision.base


def test_random_float() -> None:
    a = metavision.base.random_float((5, 10))
    assert a.shape == (5, 10)


def test_random_int() -> None:
    a = metavision.base.random_int((5, 10))
    assert a.shape == (5, 10)


def test_add_list() -> None:
    a = [0, 1, 2, 3]
    b = [4, 5, 6, 7]
    assert metavision.base.add_list(a, b) == [4, 6, 8, 10]
