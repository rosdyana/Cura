import pytest #This module contains automated tests.
import unittest.mock #For the mocking and monkeypatching functionality.

from plugins.CuraEngineBackend.ProcessSlicedLayersJob import colorCodeToRGBA

@pytest.mark.parametrize("color_compare", [
    ["#FFFFFF", [1., 1., 1., 1.]],
    ["#FF00FF", [1., 0., 1., 1.]],
    ["#00FF00", [0., 1., 0., 1.]],
    ["#000000", [0., 0., 0., 1.]]
])
def test_colorCodeToRGBA(color_compare):
    assert colorCodeToRGBA(color_compare[0]) == color_compare[1]
